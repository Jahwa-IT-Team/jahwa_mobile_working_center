import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Callback when child/parent is tapped . Map data will contain {String 'id',String 'parent_id',String 'title',Map 'extra'}

typedef OnTap = Function(Map data);

///A tree view that supports indefinite category/subcategory lists with horizontal and vertical scrolling
class DynamicTreeView extends StatefulWidget {
  ///DynamicTreeView will be build based on this.Create a model class and implement [BaseData]
  final List<BaseData> data;

  ///Called when DynamicTreeView parent or children gets tapped.
  ///Map will contain the following keys :
  ///id , parent_id , title , extra
  final OnTap onTap;

  ///The width of DynamicTreeView
  final double width;

  final String icon = "";

  ///Configuration object for [DynamicTreeView]
  final Config config;
  DynamicTreeView({
    @required this.data,
    this.config = const Config(),
    this.onTap,
    this.width = 220.0,
  }) : assert(data != null);

  @override
  _DynamicTreeViewOriState createState() => _DynamicTreeViewOriState();
}

class _DynamicTreeViewOriState extends State<DynamicTreeView> {
  List<ParentWidget> treeView;
  ChildTapListener _childTapListener = ChildTapListener(null);

  @override
  void initState() {
    _buildTreeView();
    _childTapListener.addListener(childTapListener);
    super.initState();
  }

  void childTapListener() {
    if (widget.onTap != null) {
      var k = _childTapListener.getMapValue();
      widget.onTap(k);
    }
  }

  @override
  void dispose() {
    _childTapListener.removeListener(childTapListener);
    _childTapListener.dispose();
    super.dispose();
  }

  _buildTreeView() {
    var k = widget.data
        .where((data) {
      return data.getParentId() == widget.config.rootId;
    })
        .map((data) {
      return data.getId();
    })
        .toSet()
        .toList()
      ..sort((i, j) => i.compareTo(j));

    var widgets = List<ParentWidget>();
    k.forEach((f) {
      ParentWidget p = buildWidget(f, null);
      if (p != null) widgets.add(p);
    });
    setState(() {
      treeView = widgets;
    });
  }

  ParentWidget buildWidget(String parentId, String name) {
    var data = _getChildrenFromParent(parentId);
    BaseData d = widget.data.firstWhere((d) => d.getId() == parentId.toString());
    if (name == null) {
      name = d.getTitle();
    }

    var p = ParentWidget(
      baseData: d,
      onTap: widget.onTap,
      config: widget.config,
      children: _buildChildren(data),
      key: ObjectKey({
        'id': '${d.getId()}',
        'parentId': '${d.getParentId()}',
        'title': '${d.getTitle()}',
        'icon': '${d.getIcon()}',
        'extra': '${d.getUrl()}'
      }),
    );
    return p;
  }

  _buildChildren(List<BaseData> data) {
    var cW = List<Widget>();
    for (var k in data) {
      var c = _getChildrenFromParent(k.getId());
      if ((c?.length ?? 0) > 0) {
        //has children
        var name = widget.data
            .firstWhere((d) => d.getId() == k.getId().toString())
            .getTitle();
        cW.add(buildWidget(k.getId(), name));
      } else {
        cW.add(ListTile(
          onTap: () {
            widget?.onTap({
              'id': '${k.getId()}',
              'parentId': '${k.getParentId()}',
              'title': '${k.getTitle()}',
              'icon': '${k.getIcon()}',
              'url': '${k.getUrl()}'
            });
          },
          contentPadding: widget.config.childrenPaddingEdgeInsets,
          visualDensity: widget.config.childrenVisualDensity,
          leading: IconButton(
            icon: Icon(changeIcon(k.getIcon()), color: Colors.blueAccent),
            iconSize: widget.config.iconSize,
            color: Colors.white,
            onPressed: () {},
          ),
          title: Text(
            "${k.getTitle()}",
            style: widget.config.childrenTextStyle,
          ),
        ));
      }
    }
    return cW;
  }

  List<BaseData> _getChildrenFromParent(String parentId) {
    return widget.data
        .where((data) => data.getParentId() == parentId.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return treeView != null
        ? SingleChildScrollView(
      child: Container(
        width: widget.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: treeView,
          ),
          physics: BouncingScrollPhysics(),
        ),
      ),
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
    )
        : Container();
  }
}

class ChildWidget extends StatefulWidget {
  final List<Widget> children;
  final bool shouldExpand;
  final Config config;
  ChildWidget({this.children, this.config, this.shouldExpand = false});

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> sizeAnimation;
  AnimationController expandController;

  @override
  void didUpdateWidget(ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldExpand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  void prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation curve =
    CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: sizeAnimation,
      axisAlignment: -1.0,
      child: Column(
        children: _buildChildren(),
      ),
    );
  }

  _buildChildren() {
    return widget.children.map((c) {
      // return c;
      return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: widget.config.childrenPaddingEdgeInsets,
            child: c,
          ));
    }).toList();
  }
}

class ParentWidget extends StatefulWidget {
  final List<Widget> children;
  final BaseData baseData;
  final Config config;
  final OnTap onTap;
  ParentWidget({
    this.baseData,
    this.onTap,
    this.children,
    this.config,
    Key key,
  }) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>
    with SingleTickerProviderStateMixin {
  bool shouldExpand = false;
  Animation<double> sizeAnimation;
  AnimationController expandController;

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  void prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation curve =
    CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    sizeAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          onTap: () {
            var map = Map<String, dynamic>();
            map['id'] = widget.baseData.getId();
            map['parentId'] = widget.baseData.getParentId();
            map['title'] = widget.baseData.getTitle();
            map['icon'] = widget.baseData.getIcon();
            map['url'] = widget.baseData.getUrl();
            if (widget.onTap != null) widget.onTap(map);
          },
          leading: IconButton(
            icon: FaIcon(changeIcon(widget.baseData.getIcon()), color: Colors.white),
            iconSize: widget.config.iconSize,
            color: Colors.white,
            onPressed: () {},
          ),
          title: Text(widget.baseData.getTitle(), style: widget.config.parentTextStyle),
          contentPadding: widget.config.parentPaddingEdgeInsets,
          visualDensity: widget.config.parentVisualDensity,
          trailing: IconButton(
            onPressed: () {
              setState(() {
                shouldExpand = !shouldExpand;
              });
              if (shouldExpand) {
                expandController.forward();
              } else {
                expandController.reverse();
              }
            },
            icon: RotationTransition(
              turns: sizeAnimation,
              child: widget.config.arrowIcon,
            ),
          ),
        ),
        ChildWidget(
          children: widget.children,
          config: widget.config,
          shouldExpand: shouldExpand,
        )
      ],
    );
  }
}

///A singleton Child tap listener
class ChildTapListener extends ValueNotifier<Map<String, dynamic>> {

  Map<String, dynamic> mapValue;

  ChildTapListener(Map<String, dynamic> value) : super(value);

  // ChildTapListener() : super(null);

  void addMapValue(Map map) {
    this.mapValue = map;
    notifyListeners();
  }

  Map getMapValue() {
    return this.mapValue;
  }
}

///Dynamic TreeView will construct treeview based on parent-child relationship.So, its important to
///override getParentId() and getId() with proper values.
abstract class BaseData {
  ///id of this data
  String getId();

  /// parentId of a child
  String getParentId();

  /// Text displayed on the parent/child tile
  String getTitle();

  /// Icon
  String getIcon();

  /// Url
  String getUrl();
}

class Config {
  final TextStyle parentTextStyle;
  final TextStyle childrenTextStyle;
  final EdgeInsets parentPaddingEdgeInsets;
  final EdgeInsets childrenPaddingEdgeInsets;
  final VisualDensity parentVisualDensity;
  final VisualDensity childrenVisualDensity;
  final double iconSize;

  ///Animated icon when tile collapse/expand
  final Widget arrowIcon;

  ///the rootid of a treeview.This is needed to fetch all the immediate child of root
  ///Default is Root
  final String rootId;

  const Config(
      { this.parentTextStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        this.parentPaddingEdgeInsets = const EdgeInsets.all(0.0),
        this.parentVisualDensity = const VisualDensity(horizontal: 0, vertical: 0),
        this.childrenTextStyle = const TextStyle(color: Colors.black),
        this.childrenPaddingEdgeInsets = const EdgeInsets.only(left: 10.0, top: 0, bottom: 0),
        this.childrenVisualDensity = const VisualDensity(horizontal: 0, vertical: 0),
        this.rootId = "Root",
        this.iconSize = 15,
        this.arrowIcon = const Icon(Icons.keyboard_arrow_down)});
}

//Menu Data Model
class MenuDataModel implements BaseData {
  final String id;
  final String parentId;
  String title;
  String icon;
  String url;

  ///Any extra data you want to get when tapped on children
  MenuDataModel({this.id, this.parentId, this.title, this.icon, this.url});

  @override
  String getId() {
    return this.id;
  }

  @override
  String getParentId() {
    return this.parentId;
  }

  @override
  String getTitle() {
    return this.title;
  }

  @override
  String getIcon() {
    return this.icon;
  }

  @override
  String getUrl() {
    return this.url;
  }
}

IconData changeIcon(String icon) {
  IconData ico;
  switch (icon) {
    case 'car': ico = FontAwesomeIcons.car; break;
    case 'caretRight': ico = FontAwesomeIcons.caretRight; break;
    case 'circle': ico = FontAwesomeIcons.circle; break;
    case 'cogs': ico = FontAwesomeIcons.cogs; break;
    case 'paste': ico = FontAwesomeIcons.paste; break;
    case 'server': ico = FontAwesomeIcons.server; break;
    case 'solidCalendarAlt': ico = FontAwesomeIcons.solidCalendarAlt; break;
    case 'solidEnvelope': ico = FontAwesomeIcons.solidEnvelope; break;
    case 'solidFile': ico = FontAwesomeIcons.solidFile; break;
    case 'solidFileAlt': ico = FontAwesomeIcons.solidFileAlt; break;
    case 'table': ico = FontAwesomeIcons.table; break;
    case 'tv': ico = FontAwesomeIcons.tv; break;
    case 'users': ico = FontAwesomeIcons.users; break;
    case 'vials': ico = FontAwesomeIcons.vials; break;
    default: ico = FontAwesomeIcons.folder; break;
  }
  return ico;
}