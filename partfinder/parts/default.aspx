<%@ Page Title="Partfinder > Parts > List" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .card-body{
            margin:0; padding:0;
            
        }

        #tree {
            position: relative;
            float: left;
            height: auto;
            width: 100%;
            padding: 0;
            margin: 0;
            border: none;
        }

        span.drag-source {
            border: 1px solid grey;
            border-radius: 3px;
            padding: 2px;
            background-color: silver;
        }

        ul.fancytree-container {
            height: 100%;
            width: 100%;
            overflow: auto;
            border: none;
        }

        #tree ul.fancytree-container {
            float: left;
            border: none;
            margin:0;
            padding:0;
        }

        span.fancytree-node.fancytree-drag-source {
            outline: 1px dotted grey;
        }

        span.fancytree-node.fancytree-drop-accept {
            outline: 1px dotted green;
        }

        span.fancytree-node.fancytree-drop-reject {
            outline: 1px dotted red;
        }

        span.trashcan {
            border: 1px solid #f5c6cb;
            background-color: #f8d7da;
            color: #721c24;
            padding: 1px 3px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
 <li class="breadcrumb-item active" aria-current="page">Parts List</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-12 col-md-4 col-xl-3 ">
            <div id="tree"></div>
        </div>
        <div class="col-12 col-md-8 col-xl-9"> 
             
           <div class="text-right mb-3"><a href="list.aspx" class="mr-3" title="List View"><i class="fas fa-stream mr-1"></i></a><a id="addlink" href="add.aspx" title="Add new"><i class="fa fa-plus mr-2"></i></a></div>
           <div class="card  mb-4">
                <div id="tables">
                    
                </div>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [PartCategory] ORDER BY [PCName]"></asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
    <!-- Include Fancytree skin and library -->
    <link href="/vendor/fancytree/skin-partfinder/ui.fancytree.min.css" rel="stylesheet">
    <script src="/vendor/fancytree/jquery.fancytree-all-deps.min.js"></script>

    <!-- Initialize the tree when page is loaded -->
    <script type="text/javascript">
        function loadPartPage(pkey) {
            window.location.href = '/parts/view.aspx?id=' + pkey;
        }

        function parseComponentList(key, tabletitle) {
            var JSONService = "/jsondata/parts.aspx?filter=" + key;
            $.ajax({
                type: "GET",
                contentType: "application/json",
                async: false,
                dataType: "json",
                url: JSONService
            })
                .done(function (response) {
                    var strdata = '';
                    strdata += '<div class=\'card-header py-3\'><h6 id=\'tabletitle\' class=\'m-0 font-weight-bold text-primary\'>' + tabletitle + '</h6></div>';
                    strdata += '<div id=\'tablecontent\' class=\'card-body\'>';                    
                    strdata += '<table  class=\'table border-bottom tablelinks\'>';
                    strdata += '<tr>';
                    strdata += '<th>Name</th>';
                    strdata += '<th>Description</th>';
                    strdata += '<th>Stock Level</th>';
                    strdata += '<th>Location</th>';
                    strdata += '<th>Manufacturer</th>';
                    strdata += '<th>Footprint</th>';
                    strdata += '<th></th>';
                    strdata += '</tr>';
                    $.each(response, function (index, value) {
                        strdata += '<tr onclick="loadPartPage(' + value.PartPkey + ')">';
                        strdata += '<td>' + value.PartName + '</td>';
                        strdata += '<td>' + value.PartDescription + '</td>';
                        strdata += '<td>' + value.StockLevel + '</td>';
                        strdata += '<td>' + value.StorageName + '</td>';
                        strdata += '<td>' + value.ManufacturerName + '</td>';
                        strdata += '<td>' + value.FootprintName + '</td>';
                        strdata += '<td class="text-right"><a href="/parts/view.aspx?id=' + value.PartPkey + '" ><i class="fa fa-search text-primary fa-1x "></i></a></td>';
                        strdata += '</tr>';
                    })

                    strdata += '</table>';
                    strdata += '</div>';
                    $("#tables").append(strdata);

                })
                .fail(function (jqXHR, textStatus) { alert("error" + textStatus); })
                .always(function () { //alert("complete"); 
                });

            //var obj = jQuery.parseJSON(data);
            //alert(obj.name === "John");
        }

        function buildTree(node) {
            $("#tables").html('');
            parseComponentList(node.key, node.title);
            title = node.title;
            // load children
            /*var children = node.children;
            if (children != null) {
                for (var i = 0; i < children.length; i++) {
                    var child = children[i];
                    buildSubTree(child, title);
                }
            }
            */
            
        }

        function buildSubTree(node, title) {
            subtitle = title + ' > ' + node.title;
            parseComponentList(node.key, subtitle);
            
            // load children
            var children = node.children;
            if (children != null) {
                for (var i = 0; i < children.length; i++) {
                    var child = children[i];
                    childtitle = subtitle + ' > ' + child.title;
                    parseComponentList(child.key, childtitle);
                }
            }
            

        }


        $(function () {  // on page load
            var LAST_EFFECT_DO = null,
                LAST_EFFECT_DD = null,
                lazyLogCache = {};

            /* Log if value changed, nor more than interval/sec.*/
            function logLazy(name, value, interval, msg) {
                if (!lazyLogCache[name]) { lazyLogCache[name] = { stamp: now } };
                var now = Date.now(),
                    entry = lazyLogCache[name];

                if (value && value === entry.value) {
                    return;
                }
                entry.value = value;

                if (interval > 0 && (now - entry.stamp) <= interval) {
                    return;
                }
                entry.stamp = now;
                lazyLogCache[name] = entry;
                console.log(msg);
            }

            // Create the tree inside the <div id="tree"> element.
            $("#tree").fancytree({
                minExpandLevel: 1,

                treeId: "1",
                extensions: ["filter", "persist"],
                source: {
                    url: "/jsondata/categorymenu.aspx",
                    cache: true
                },
                persist: {
                    // Available options with their default:
                    cookieDelimiter: "~",    // character used to join key strings
                    cookiePrefix: undefined, // 'fancytree-<treeId>-' by default
                    cookie: { // settings passed to jquery.cookie plugin
                        raw: false,
                        expires: "",
                        path: "",
                        domain: "",
                        secure: false
                    },
                    expandLazy: false, // true: recursively expand and load lazy nodes
                    expandOpts: undefined, // optional `opts` argument passed to setExpanded()
                    overrideSource: true,  // true: cookie takes precedence over `source` data attributes.
                    store: "auto",     // 'cookie': use cookie, 'local': use localStore, 'session': use sessionStore
                    types: "active expanded focus selected"  // which status types to store
                },
                activate: function (event, data) {
                    
                    var node = data.node;
                    node.sortChildren(null, false);
                    buildTree(node);
                    $("#addlink").attr("href", "add.aspx?c=" + node.key);
                },
            });
            // Note: Loading and initialization may be asynchronous, so the nodes may not be accessible yet.
        });


        
    </script>
</asp:Content>
