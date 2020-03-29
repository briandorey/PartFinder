<%@ Page Language="C#" ContentType="text/html" EnableViewState="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Drawing.Drawing2D" %>
<script language="C#" runat="server">
    protected void Page_Load(Object Src, EventArgs E)
    {
        if (!IsPostBack)
        {
            PopPage();
            if ((Request.QueryString["d"] == null || Request.QueryString["d"] == "\\" || Request.QueryString["d"].Length < 1))
            {
                Panel1.Visible = false; ;
                upLink.ImageUrl = "/img/folder.svg";
                upLink.NavigateUrl = "";
            }
        }
    }
  
    public string GetFolderPath()
    {
        if (Request.QueryString["d"] != null && Request.QueryString["d"].Length != 0)
        {
            return Request.QueryString["d"].Replace("\\\\", "\\") + "\\";
        }
        return "\\";

    }
    public void PopPage()
    {
        string strDir = "\\";
        try
        {
            if (Request.QueryString["d"] != null && Request.QueryString["d"].Length != 0)
            {
                strDir = Request.QueryString["d"];
            }
            string strParent = strDir.Substring(0, strDir.LastIndexOf("\\"));
            //strParent += strParent.EndsWith(":") ? "\\" : "";
            upLink.NavigateUrl = "filebrowser.aspx?d=" + strParent.Replace("\\\\", "\\") + "&fn=" + Request.QueryString["fn"]  + "&fieldname=" + Request.QueryString["fieldname"] ;


            txtCurrentDir.Text = "Directory: <b>" + strDir.Replace("\\\\", "\\") + "</b>";


            DirectoryInfo DirInfo = new DirectoryInfo(Server.MapPath("\\docs\\" + strDir));
            DirectoryInfo[] subDirs = DirInfo.GetDirectories();
            FileInfo[] Files = DirInfo.GetFiles();

            DataTable dt = new DataTable();
            DataColumn dc = new DataColumn("FileDirectory", typeof(System.String));
            DataColumn dc1 = new DataColumn("FileDirectoryPath", typeof(System.String));
            dt.Columns.Add(dc);
            dt.Columns.Add(dc1);
            for (int i = 0; i <= subDirs.Length - 1; i++)
            {
                DataRow dro = dt.NewRow();
                dro[0] = subDirs[i].Name;
                dro[1] = subDirs[i].LastWriteTime;

                dt.Rows.Add(dro);

            }
            DataView dvDirs = new DataView(dt);
            dvDirs.Sort = "FileDirectory";
            dirrep.DataSource = dvDirs;
            dirrep.DataBind();
            dvDirs.Dispose();

            // do files
            DataTable dtfiles = new DataTable();
            DataColumn dcfiles = new DataColumn("FileName", typeof(System.String));
            DataColumn dc1files = new DataColumn("FilePath", typeof(System.String));
            DataColumn dc2files = new DataColumn("FileSize", typeof(System.String));
            DataColumn dc3files = new DataColumn("FileDate", typeof(System.String));
            dtfiles.Columns.Add(dcfiles);
            dtfiles.Columns.Add(dc1files);
            dtfiles.Columns.Add(dc2files);
            dtfiles.Columns.Add(dc3files);

            for (int i = 0; i <= Files.Length - 1; i++)
            {

                DataRow dro = dtfiles.NewRow();
                dro[0] = Files[i].Name;
                dro[1] = GetFolderPath().Replace("\\\\", "\\") + Files[i].Name;
                dro[2] = Files[i].Length.ToString().DoSizeFormat();
                dro[3] = Files[i].LastWriteTime;

                dtfiles.Rows.Add(dro);

            }

            if (dtfiles.Rows.Count == 0)
            {
                txtNofiles.Text = "<div class=\"noimagebox\">No Files Found</div>";
            }
            DataView dvFiles = new DataView(dtfiles);
            dvFiles.Sort = "FileName";
            filerep.DataSource = dvFiles;
            filerep.DataBind();
            dvFiles.Dispose();

        }
        catch (Exception e)
        {
            txtCurrentDir.Text = "Error retrieving directory info: " + e.Message;
        }

    }

    public string MakeIcon(string FileName)
    {
        string returnstring = "";
        if (FileName.ToLower().EndsWith("jpg") || FileName.EndsWith("gif") || FileName.EndsWith("svg") || FileName.EndsWith("png"))
        {
            returnstring = "/docs/" + FileName;
        }
        else
        {
            returnstring = "/img/file.svg";
        }
        return returnstring;
    }
</script>
<!doctype html>

<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Files &amp; Images</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="/css/layout.css" rel="stylesheet" />
    <script> 

        function copydate(sdate, imgpath) {
            if (parent.document.forms['<%= Request.QueryString["fn"] %>'] != null) {
               parent.document.forms['<%= Request.QueryString["fn"] %>'].elements['<%= Request.QueryString["fieldname"] %>'].value = sdate;
        <% if ((Request.QueryString["dImage"] != null && Request.QueryString["dImage"].Length > 0)){ %>
        parent.document.images['<%= Request.QueryString["dImage"] %>'].src = '/docs' + imgpath;
        //parent.document.images['<%= Request.QueryString["dImage"] %>'].src='/docs & imgpath & '';
        <% } %>
    } else {

        opener.document.forms['<%= Request.QueryString["fn"] %>'].elements['<%= Request.QueryString["fieldname"] %>'].value = sdate;
        <% if ((Request.QueryString["dImage"] != null && Request.QueryString["dImage"].Length > 0)){ %>
        opener.document.images['<%= Request.QueryString["dImage"] %>'].src = '/docs' + imgpath;
         <% } %>
               window.close();
           }

       }
    </script>
    <style>
        .images img {
            
            height: auto;
            max-width: 90%;
            max-height: 75px;
            margin: 0 auto;
        }
        .folders img { 
            height: auto;
            width:60px;
            height: 75px;
            margin: 0 auto;
        }
        body { color: #4b4b4b;}
        h5 {font-weight: 300;}
    </style>
</head>
<body>
    <form runat="server" id="Form1">
        <div class="container-fluid">
            <div class="row">
                <div class="col my-3 ml-3 ">
                   <h5><asp:Label ID="txtCurrentDir" runat="server" /></h5>
                </div>
            </div>
           
            <div class="row">
             <asp:Panel ID="Panel1" runat="server">    <div class="col mx-3  small folders">
                    <p>
                        <asp:HyperLink ID="upLink" runat="server" ImageUrl="/img/folder-open.svg"  /></p>
                    <p>Up</p>
                </div></asp:Panel>
                <asp:Repeater runat="server" ID="dirrep">
                    <ItemTemplate>
                        <div class="col  mx-3 small folders">
                            <p><a href="filebrowser.aspx?d=<%= GetFolderPath().Replace("\\\\","\\") %><%# DataBinder.Eval(Container.DataItem, "FileDirectory") %>&fn=<%= Request.QueryString["fn"] %>&fieldname=<%= Request.QueryString["fieldname"] %>">
                                <img src="/img/folder.svg" alt="Show Contents" border="0"></a></p>
                            <p><%# DataBinder.Eval(Container.DataItem, "FileDirectory") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Repeater runat="server" ID="filerep">
                    <ItemTemplate>
                        <div class="col small images text-center">
                            <p><a href="#" onclick="copydate('/docs<%# ((string) DataBinder.Eval(Container.DataItem, "FilePath")).Replace("\\","/") %>');">
                                <img src="<%# MakeIcon((String)(DataBinder.Eval(Container.DataItem,"FilePath"))) %>" alt="Select File or Image" class="img-fluid" border="0"></a></p>
                            <p><%# DataBinder.Eval(Container.DataItem, "FileName") %><br />
                                <%# DataBinder.Eval(Container.DataItem, "FileSize") %><br />
                                <%# DataBinder.Eval(Container.DataItem, "FileDate") %></p>
                        </div>
                    </ItemTemplate>

                </asp:Repeater>
                <asp:Label ID="txtNofiles" runat="server" />

            </div>
        </div>
    </form>
</body>
</html>
