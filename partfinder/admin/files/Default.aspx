<%@ Page Title="File Manager" Language="C#" MasterPageFile="~/MasterPage.master"  %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Drawing.Drawing2D" %>

<script runat="server">
    public string BasePath = "";
    
    string FullUrl = "";

    string userSettings = "list";

    protected void Page_Load(Object Src, EventArgs E)
    {
        BasePath = Server.MapPath("\\docs\\");
        PopPage();

        if (Request.Cookies["FileManagerView"] != null)
        {

            if (Request.Cookies["FileManagerView"]["ViewMode"] != null)
            {
                userSettings = Request.Cookies["FileManagerView"]["ViewMode"];
            }
        }

       
        if (Helpers.QueryStringIsNotNull("d"))
        {
            string currentpath = Helpers.CleanQS("d").Replace("\\", "|");
            FullUrl = Helpers.CleanQS("d");


           


            StringBuilder sb = new StringBuilder();
            char[] MyChar = { '|' };

            currentpath = currentpath.TrimStart(MyChar);
            string[] words = currentpath.Split('|');
            int totallength = words.Length;
            if (currentpath.Length == 0)
            {
                totallength = 0;
            }


            int tmpcounter = 0;

            if (totallength == 0)
            {
                sb.Append("<li  class=\"breadcrumb-item\"><a href=\"default.aspx\">Files</a></li><li class=\"breadcrumb-item active\">docs</li>");

            }
            else
            {
                sb.Append("<li  class=\"breadcrumb-item\"><a href=\"default.aspx\">Files</a></li><li  class=\"breadcrumb-item\"><a href=\"default.aspx\">docs</a></li>");


                foreach (string word in words)
                {
                    if (word.Trim().Length > 1)
                    {
                        if (tmpcounter == totallength - 1)
                        {
                            sb.Append("<li class=\"breadcrumb-item active\">" + word + "</li>");

                        }
                        else
                        {
                            sb.Append("<li  class=\"breadcrumb-item\"><a href=\"default.aspx?d=" + TrimUrl(FullUrl, word) + "\">" + word + "</a></li>");
                        }

                        tmpcounter++;
                    }

                }
            }
            LitBread.Text = sb.ToString();
        }
        else
        {
            LitBread.Text = "<li  class=\"breadcrumb-item\"><a href=\"default.aspx\">Files</a></li><li class=\"breadcrumb-item active\">docs</li>";
           
        }

        var sbtree = new StringBuilder();

        ListDirectories(Server.MapPath("/docs"), sbtree, BasePath);
        foldertree.Text = sbtree.ToString();
       
    }

    void ListDirectories(string path, StringBuilder sb, string BasePath)
    {

        var directories = Directory.GetDirectories(path);
        if (directories.Any())
        {
            sb.AppendLine("<ul>");
            foreach (var directory in directories)
            {
                var di = new DirectoryInfo(directory);

                if (FullUrl.Equals("\\" + di.FullName.Replace(BasePath, ""))) {
                    sb.AppendFormat("    <li><a href=\"default.aspx?d=\\" + di.FullName.Replace(BasePath, "") + "\"  data=\""  + di.FullName.Replace(BasePath,"") + "\"><i class=\"fa fa-folder-open fa-lg mr-2 text-dark\" aria-hidden=\"true\"></i><strong class=\"text-dark\">{0}</strong></a>", di.Name);
                }
                else
                {
                    sb.AppendFormat("    <li><a href=\"default.aspx?d=\\" + di.FullName.Replace(BasePath, "") + "\" data=\""  + di.FullName.Replace(BasePath,"") + "\"><i class=\"fa fa-folder fa-lg mr-2\" aria-hidden=\"true\"></i>{0}</a>", di.Name);
                }



                sb.AppendLine();
                ListDirectories(directory, sb, BasePath);
                sb.AppendLine("</li>");
            }
            sb.AppendLine("</ul>");
        }
    }
    public string TrimUrl(string link, string lastlink)
    {
        string[] parts = link.Split('\\');
        StringBuilder linker = new StringBuilder();
        foreach (string part in parts)
        {
            linker.Append("\\" + part);
            if (part.Equals(lastlink))
            {
                return linker.ToString();
            }
        }
        return linker.ToString();
    }
    public string GetFolderPath()
    {
        if (Helpers.QueryStringIsNotNull("d"))
        {
            return Helpers.CleanQS("d").Replace("\\\\", "\\");
        }
        return "\\";

    }
   
    public void PopPage()
    {
        string strDir = "\\";
        try
        {
            if (Helpers.QueryStringIsNotNull("d"))
            {
                strDir = Helpers.CleanQS("d");;
            }
            string strParent = strDir.Substring(0, strDir.LastIndexOf("\\"));
          


            DirectoryInfo DirInfo = new DirectoryInfo(Server.MapPath("\\docs\\" + strDir));
            DirectoryInfo[] subDirs = DirInfo.GetDirectories();
            FileInfo[] Files = DirInfo.GetFiles();



            // do files
            DataTable dtfiles = new DataTable();
            DataColumn dcfiles = new DataColumn("FileName", typeof(System.String));
            DataColumn dc1files = new DataColumn("FilePath", typeof(System.String));
            DataColumn dc2files = new DataColumn("FileSize", typeof(System.String));
            DataColumn dc3files = new DataColumn("FileDate", typeof(System.DateTime));
            DataColumn dc4files = new DataColumn("FileType", typeof(System.String));
            dtfiles.Columns.Add(dcfiles);
            dtfiles.Columns.Add(dc1files);
            dtfiles.Columns.Add(dc2files);
            dtfiles.Columns.Add(dc3files);
            dtfiles.Columns.Add(dc4files);
            for (int i = 0; i <= Files.Length - 1; i++)
            {
                DataRow dro = dtfiles.NewRow();
                dro[0] = Files[i].Name;
                dro[1] = GetFolderPath() + "\\" + Files[i].Name;
                dro[2] = DoSizeFormat(Files[i].Length.ToString());
                dro[3] = DateTime.Parse(Files[i].LastWriteTime.ToString());
                dro[4] = Files[i].Extension;
                dtfiles.Rows.Add(dro);
            }

            if (dtfiles.Rows.Count == 0)
            {
                txtNofiles.Text = "<div class=\"noimagebox\">This folder does not contain any files.</div>";
                PagingNav1.Visible = false;
                PagingNav2.Visible = false;
            }

            DataView dvFiles = new DataView(dtfiles);
            //dvFiles.Sort = GetFileSort();

            PagedDataSource objPds = new PagedDataSource();
            objPds.DataSource = dvFiles;
            objPds.AllowPaging = true;
            objPds.PageSize = 60;
            int CurPage;
            if (Request.QueryString["Page"] != null)
                CurPage = Convert.ToInt32(Helpers.CleanQS("Page"));
            else
                CurPage = 1;

            objPds.CurrentPageIndex = CurPage - 1;
            filerep.DataSource = objPds;
            if ((Helpers.QueryStringIsNotNull("d") && Request.QueryString["d"] == "\\") || (Request.QueryString["d"] == null))
            {
                PagingNav1.Text = CreatePagerLinks(objPds, "default.aspx?");
                PagingNav2.Text = CreatePagerLinks(objPds, "default.aspx?");
            }
            else
            {
                PagingNav1.Text = CreatePagerLinks(objPds, "default.aspx?d=" + Helpers.CleanQS("d"));
                PagingNav2.Text = CreatePagerLinks(objPds, "default.aspx?d=" + Helpers.CleanQS("d"));
            }

            filerep.DataBind();
            dvFiles.Dispose();



        }
        catch (Exception)
        {
            //SetPageTitle("Error retrieving directory info: "+e.Message);
        }

    }

    public static string CreatePagerLinks(PagedDataSource objPds, string BaseUrl)
    {
        StringBuilder sbPager = new StringBuilder();
        sbPager.Append("<strong>Files | Page:</strong> ");
        if (!objPds.IsFirstPage)
        {
            // first page link
            sbPager.Append("<a href=\"");
            sbPager.Append(BaseUrl);
            sbPager.Append("\"><</a> ");
            if (objPds.CurrentPageIndex != 1)
            {
                // previous page link
                sbPager.Append("<a href=\"");
                sbPager.Append(BaseUrl);
                sbPager.Append("&page=");
                sbPager.Append(objPds.CurrentPageIndex.ToString());
                sbPager.Append("\" alt=\"Previous Page\"><<</a>  ");
            }
        }
        // calc low and high limits for numeric links
        int intLow = objPds.CurrentPageIndex - 1;
        int intHigh = objPds.CurrentPageIndex + 3;
        if (intLow < 1) intLow = 1;
        if (intHigh > objPds.PageCount) intHigh = objPds.PageCount;
        if (intHigh - intLow < 10) while ((intHigh < intLow + 9) && intHigh < objPds.PageCount) intHigh++;
        if (intHigh - intLow < 10) while ((intLow > intHigh - 9) && intLow > 1) intLow--;
        for (int x = intLow; x < intHigh + 1; x++)
        {
            // numeric links
            if (x == objPds.CurrentPageIndex + 1) sbPager.Append(x.ToString() + "  ");
            else
            {
                sbPager.Append("<a href=\"");
                sbPager.Append(BaseUrl);
                sbPager.Append("&page=");
                sbPager.Append(x.ToString());
                sbPager.Append("\">");
                sbPager.Append(x.ToString());
                sbPager.Append("</a>  ");
            }
        }
        if (!objPds.IsLastPage)
        {
            if ((objPds.CurrentPageIndex + 2) != objPds.PageCount)
            {
                // next page link
                sbPager.Append("<a href=\"");
                sbPager.Append(BaseUrl);
                sbPager.Append("&page=");
                sbPager.Append(Convert.ToString(objPds.CurrentPageIndex + 2));
                sbPager.Append("\">>></a>  ");
            }
            // last page link
            sbPager.Append("<a href=\"");
            sbPager.Append(BaseUrl);
            sbPager.Append("&page=");
            sbPager.Append(objPds.PageCount.ToString());
            sbPager.Append("\">></a>");
        }
        // conver the final links to a string and assign to labels
        return sbPager.ToString();
    }

    public string DoSizeFormat(string invalue)
    {
        double filesize = System.Convert.ToDouble(invalue);
        string displayvalue = "";

        if (filesize < 1024)
        {
            displayvalue = (filesize).ToString("F") + " B";
        }
        if (filesize >= 1024)
        {
            displayvalue = (filesize / 1024).ToString("F") + " KB";
        }
        if (filesize >= 1048576)
        {
            displayvalue = (filesize / 1024 / 1024).ToString("F") + " MB";
        }
        if (filesize >= 1073741824)
        {
            displayvalue = (filesize / 1024 / 1024 / 1024).ToString("F") + " GB";
        }

        if (filesize < 1)
        {
            displayvalue = "0 B";
        }

        return displayvalue;

    }

    public string MakeIcon(string FileName, bool popup)
    {

        FileName = FileName.Replace("\\", "/");
        if ((FileName.ToLower().EndsWith("jpg") || FileName.EndsWith("gif") || FileName.EndsWith("png")))
        {
            if (popup)
            {
                return "/docs" + FileName;
            }
            else
            {
                return "/docs" + FileName;
            }
        }
        if (FileName.ToLower().EndsWith("svg"))
        {
            return "/docs" + FileName;
        }
        if (FileName.ToLower().EndsWith("doc") || FileName.ToLower().EndsWith("docx"))
        {
            return "//images/file-word.svg";
        }
        if (FileName.ToLower().EndsWith("xls") || FileName.ToLower().EndsWith("xlsx"))
        {
            return "//images/file-excel.svg";
        }
        if (FileName.ToLower().EndsWith("txt") || FileName.ToLower().EndsWith("py"))
        {
            return "//images/file-code.svg";
        }
        if (FileName.ToLower().EndsWith("zip") || FileName.ToLower().EndsWith("rar"))
        {
            return "//images/archive.svg";
        }
        if (FileName.ToLower().EndsWith("pdf"))
        {
            return "//images/file-pdf.svg";
        }
        if (FileName.ToLower().EndsWith("mpg") || FileName.ToLower().EndsWith("mp4"))
        {
            return "//images/file-video.svg";
        }

        return "//images/file-alt.svg";

    }

    public string GetType(string inval)
    {
        switch (inval.Right(3))
        {
            case "jpg":
                return "JPG Image";

            case "gif":
                return "GIF Image";

            case "doc":
                return "Word Document";

            case "zip":
                return "Compressed File";

            case "pdf":
                return "Acrobat Document";

            case "xls":
                return "Excel Spreadsheet";

            case "ppt":
                return "Powerpoint";

            case "txt":
                return "Text";

            case "avi":
                return "AVI Video";

            case "mpg":
                return "MPG Video";

            case "mov":
                return "Quicktime Video";

            case "mp3":
                return "Audio File";

            default:
                return "Not Known";

        }
    }

    private string getfilecount(string folder)
    {
        string[] files = Directory.GetFiles(folder, "*.*", SearchOption.AllDirectories);

        return files.Length.ToString();

    }

    protected void ButtonAddFolder_Click(object sender, EventArgs e)
    {
        if (SectionName.Text != null && SectionName.Text.Length > 0)
        {
            if (Helpers.QueryStringIsNotNull("d"))
            {

                string DirToAdd = Helpers.CleanQS("d");
                string newDirName = Regex.Replace(SectionName.Text, @"\W*", "").ToLower();
                
                Directory.CreateDirectory(@Server.MapPath("\\docs\\" + Helpers.CleanQS("d")) + "\\" + newDirName);
                Response.Redirect("default.aspx?d=" + Helpers.CleanQS("d"));
            }
            else
            {
                string newDirName = Regex.Replace(SectionName.Text, @"\W*", "").ToLower();
                
                Directory.CreateDirectory(@Server.MapPath("\\docs\\" + newDirName));
                Response.Redirect("default.aspx?");
            }
        }
    }

    

    // upload file from input field

    void UploadFile(object Sender,EventArgs E)
    {
        string FileToSave = "";
        if (Page.IsValid == true) {






            HttpFileCollection uploadFilCol = Request.Files;
            for(int i=0;i<uploadFilCol.Count;i++)
            {
                HttpPostedFile file = uploadFilCol[i];
                string fileExt = Path.GetExtension(file.FileName).ToLower();
                string fileName = Path.GetFileName(file.FileName);
                if(fileName != string.Empty)
                {
                    string FfileName = fileName.ToLower().Replace(" ","_");
                    string StrFileType = File1.PostedFile.ContentType ;
                    long fsize =file.ContentLength;
                    string FfileExt = FfileName.Right(3).ToLower();
                    // cleanup filename
                    FfileName = FfileName.Replace("&","");
                    if (FfileName.Length > 30) {
                        FfileName = FfileName.Left(30) + "." + FfileExt;
                    }
                    if (Helpers.QueryStringIsNotNull("d"))
                    {
                        string currentpath = Helpers.CleanQS("d").Replace("\\", "|");
                        FullUrl = Helpers.CleanQS("d") + "\\";
                    }
                    FileToSave = Server.MapPath("\\docs\\" + FullUrl +   FfileName);

                    if (fsize <=0)
                        litError.Text = "The selected file has zero size.";

                    else
                    {
                        // check for file type
                        if ((FfileExt == "swf") || (FfileExt == "jpg") || (FfileExt == "gif") || (FfileExt == "doc") || (FfileExt == "zip") || (FfileExt == "pdf") || (FfileExt == "xls") || (FfileExt == "ppt") || (FfileExt == "txt") || (FfileExt == "avi") || (FfileExt == "mpg") || (FfileExt == "mov") || (FfileExt == "png") || (FfileExt == "mp3"))
                        {
                            //file is ok
                        }
                        else
                        {
                            litError.Text = "The selected file type is now allowed to be added to your website.";
                        }
                        // Save file
                        file.SaveAs(FileToSave);

                    }

                    // end upload loop


                }
            }
            Response.Redirect("default.aspx?d=" + Helpers.CleanQS("d"));
            //litError.Text = "File Uploaded." + FileToSave;

        }
    }

    public string CheckListMode(bool IsIconMode)
    {
        if (userSettings.Equals("icon") && IsIconMode) {
            return "";
        } 
        if (userSettings.Equals("list") && !IsIconMode) {
            return "";
        } 

        return "hidden";
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        #drop_zone {
            margin: 10px 0;
            width: 100%;
            text-align: center;
            border: 5px dashed #666;
            color: #666;
            padding: 30px 0px;
        }

        #myModal .modal-dialog {
            -webkit-transform: translate(0,-50%);
            -o-transform: translate(0,-50%);
            transform: translate(0,-50%);
            top: 50%;
            margin: 0 auto;
        }
        .hidden { display: none; visibility:hidden; height: 0;}
    </style>
    <script>
        var files;
        function handleDragOver(event) {
            event.stopPropagation();
            event.preventDefault();
            var dropZone = document.getElementById('drop_zone');
            dropZone.innerHTML = "Ready to Upload";
        }

        function handleDnDFileSelect(event) {
            event.stopPropagation();
            event.preventDefault();

            /* Read the list of all the selected files. */
            files = event.dataTransfer.files;

            /* Consolidate the output element. */
            var form = document.getElementById('form1');
            var data = new FormData(form);

            for (var i = 0; i < files.length; i++) {
                data.append(files[i].name, files[i]);
            }
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200 && xhr.responseText) {
                    var dropZone = document.getElementById('drop_zone');
                    dropZone.innerHTML = xhr.responseText;
                } else {
                    var dropZone = document.getElementById('drop_zone');
                    dropZone.innerHTML = xhr.responseText;
                }
            };
            xhr.open('POST', "upload.ashx?<%=  Request.QueryString %>");
            // xhr.setRequestHeader("Content-type", "multipart/form-data");
            xhr.send(data);

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
   <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item active" aria-current="page">File Manager</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 col-md-8">
            <p>The file manager allows you to manage your uploads and attachments.</p>
        </div>
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header  d-flex flex-row align-items-center justify-content-between">
                  <ol class="breadcrumb bg-transparent m-0 pl-0 m-0 text-primary">
                            <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
                            <asp:Literal ID="LitBread" runat="server"></asp:Literal>
                        </ol>
                    <div class=" form-inline">

                       
                    <label class="mr-sm-2" for="SectionName">Add Folder</label>
                    <asp:TextBox ID="SectionName" CssClass="form-control form-control-sm mb-2 mr-sm-2 mb-sm-0" MaxLength="50" TextMode="SingleLine" runat="server" Wrap="false" />
                    <asp:Button ID="ButtonAddFolder" Text="Add" runat="server" OnClick="ButtonAddFolder_Click" CssClass="btn btn-primary btn-sm" />
                </div>
                </div>
                <div class="card-body p-0 pb-3">
                    <!-- start content -->

                   

	<div class="row mt-2 p-3">
        <div class="col-12 col-md-3 ">
            <h4>Add new file(s)</h4>
            <div id="drop_zone">Drop New files here</div>
            <script>
                if (window.File && window.FileList && window.FileReader) {
                    var dropZone = document.getElementById('drop_zone');
                    dropZone.addEventListener('dragover', handleDragOver, false);
                    dropZone.addEventListener('drop', handleDnDFileSelect, false);

                }
                else {
                    alert('Sorry! this browser does not support HTML5 File APIs.');
                }
            </script>
            <asp:Literal ID="litError" runat="server"></asp:Literal>
            <hr />
             <div class="row">
    <div class="col-6">
   <input name="File1" type="file" class="form-control-file  form-control-sm" id="File1" runat="server"  accept=".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf"> </div>
    <div class="col-6 text-right"><input type="button" class="btn btn-primary btn-sm" id="CmdUpload" value="Upload your files" runat="server"  onserverclick="UploadFile" /> </div>
                 </div>
            <hr />
            <h4>Sub Folders</h4>
             <div id="treeview"> 
                <asp:Literal ID="foldertree" runat="server"></asp:Literal>
            </div>
            <asp:Literal ID="litFolderTree" runat="server"></asp:Literal>
        </div>
        <div class="col-12 col-md-9">
 
            <asp:Label ID="txtNofiles" runat="server" />
            <div class="row mb-2">
                <div class="col-12 col-sm-8"><asp:Label ID="PagingNav1" runat="server" /></div>
                <div class="col-12 col-sm-4 text-right">  <a href="javascript:;" id="listmodeicons" title="View Icons"><i class="fas fa-image  fa-2x mr-2 text-secondary" aria-hidden="true"></i></a>  <a href="javascript:;" id="listmodelist" title="View List"><i class="fa fa-list fa-2x text-secondary" aria-hidden="true"></i></a></div>
                </div>
               <div class="row bg-light pt-3 pb-3 mb-1 font-weight-bold <%= CheckListMode(false) %>" id="listmodeheader">
                            <div class="col-1"></div>
                    <div class="col-5">Name</div>
                            <div class="col-3">Size</div>
                            <div class="col-3">Modified</div>
                                </div>
            <div class="row">
             
                <asp:Repeater runat="server" ID="filerep">
                    <ItemTemplate>
                        <div class="col-12 pb-2 pt-2 listmode <%= CheckListMode(false) %>" style="border-bottom: 1px solid #ededed;" onclick="showinfo('<%# DataBinder.Eval(Container.DataItem, "FileName").ToString() %>', '<%# DataBinder.Eval(Container.DataItem, "FileSize").ToString() %>', '<%# DataBinder.Eval(Container.DataItem, "FileDate").ToString().DoDateFormat()%>', '<%# (MakeIcon((String)(DataBinder.Eval(Container.DataItem,"FilePath")), false)) %>', '<%# DataBinder.Eval(Container.DataItem, "FilePath").ToString().Replace("\\","/") %>');">
                            <div class="row">
                            <div class="col-1 text-center align-content-center">
                                <img class=" img-fluid my-auto" style="max-height: 25px; max-width: 50px; margin: 0 auto;" src="<%# MakeIcon((String)(DataBinder.Eval(Container.DataItem,"FilePath")), true) %>" alt="Preview">
                                </div>
                                 <div class="col-5 align-content-center"><%# DataBinder.Eval(Container.DataItem, "FileName").ToString() %></div>
                            <div class="col-3 align-content-center"><%# DataBinder.Eval(Container.DataItem, "FileSize").ToString() %></div>
                            <div class="col-3 align-content-center"><%# DataBinder.Eval(Container.DataItem, "FileDate").ToString().DoDateFormat()%></div>
                               
                            
                                </div>
                            <div style="clear: both;"></div>
                        </div>
                       
                        
                        <div class="col-6 col-lg-2  col-md-3 mb-2  d-flex align-items-stretch iconmode <%= CheckListMode(true) %>">
                            <div class="card w-100" onclick="showinfo('<%# DataBinder.Eval(Container.DataItem, "FileName").ToString() %>', '<%# DataBinder.Eval(Container.DataItem, "FileSize").ToString() %>', '<%# DataBinder.Eval(Container.DataItem, "FileDate").ToString().DoDateFormat()%>', '<%# (MakeIcon((String)(DataBinder.Eval(Container.DataItem,"FilePath")), false)) %>', '<%# DataBinder.Eval(Container.DataItem, "FilePath").ToString().Replace("\\","/") %>');">
                                <img class="card-img-top img-fluid mt-2 " style="max-height: 75px; max-width: 75px; margin: 0 auto;" src="<%# MakeIcon((String)(DataBinder.Eval(Container.DataItem,"FilePath")), true) %>" alt="Preview">
                                <div class="card-body ">
                                    <p class="card-text  align-content-center"><%# DataBinder.Eval(Container.DataItem, "FileName").ToString() %></p>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="fmrowpaging" style="clear: left; margin: 20px 0 0 0;">
                <asp:Label ID="PagingNav2" runat="server" /></div> 
            
            <% if (Helpers.QueryStringIsNotNull("d") && Request.QueryString["d"].Length > 2)
                        { %>
            <div class="alert alert-danger mt-5 text-center" role="alert">
  <p>If you would like to delete this folder and all its files, press the button below. This is not reversable.</p>
                    <a href="Javascript:Folderconfirmation();" class="btn btn-danger btn-sm mt-3"><i class="fa fa-trash mr-3" aria-hidden="true"></i>Delete Folder</a>
</div>
            
                    <% } %>
        </div>
    </div>
 <!-- end content -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal For file info -->
    <div class="modal fade" id="myModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">File Information</h4>
                </div>
                <div class="modal-body">
                    <p class="text-center">
                        <img id="modalimage" class="img-fluid" src="//images/folder.svg" style="min-height: 200px; max-height: 300px; max-width: 400px;" /></p>
                    <h4 id="modalname">Name: </h4>
                    <p id="modalsize">Size: </p>
                    <p id="modaldate">Date: </p>
                    <div id="modalfileinfo"></div>
                </div>
                <div class="modal-footer">
                    <a id="modaldelete" href="Javascript:;" class="mr-5  mr-auto" title="Delete File"><i class="fas fa-trash fa-3x text-danger"></i></a>
                    <a id="modaldownload" href="Javascript:;" class="mr-5 mr-auto" title="Download File"><i class="fa fa-download fa-3x" aria-hidden="true"></i></a>
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
      <script type="text/javascript">
          function Folderconfirmation() {
              var answer = confirm("Are you sure you want to delete this folder and all files and subfolders within this folder?\nPlease Note: This action will log you out of  to reload your folder settings.")
              if (answer) {
                  window.location = "delete.aspx?f=<%= GetFolderPath().Replace("\\","/") %>&mode=folder";
              }
          }

          function confirmation(filepath) {
              var answer = confirm("Are you sure you want to delete this file?")
              if (answer) {
                  window.location = 'delete.aspx?f=' + filepath + '&mode=file';
              }
          }

          $("#listmodeicons").click(function () {
              $("#listmodeheader").hide();
              $(".iconmode").removeClass('hidden');
              $(".listmode").addClass('hidden');

              $("#listmodelist i").removeClass('text-primary');
              $("#listmodelist i").addClass('text-secondary');

              $("#listmodeicons i").removeClass('text-secondary');
              $("#listmodeicons i").addClass('text-primary');


              $.ajax({
                  url: '//files/viewmode.aspx?mode=icon',
                  cache: false
              }).done(function (data) {

              });
          });

          $("#listmodelist").click(function () {
              $("#listmodeheader").show();
              $("#listmodeheader").removeClass('hidden');
              $(".listmode").removeClass('hidden');
              $(".iconmode").addClass('hidden');

              $("#listmodeicons i").removeClass('text-primary');
              $("#listmodeicons i").addClass('text-secondary');

              $("#listmodelist i").removeClass('text-secondary');
              $("#listmodelist i").addClass('text-primary');



              $.ajax({
                  url: '//files/viewmode.aspx?mode=list',
                  cache: false
              }).done(function (data) {

              });

          });

          function showinfo(filename, fileSize, fileDate, fileimage, filepath) {

              $('#modalimage').attr("src", fileimage);
              $('#modalname').html('Name: ' + filename)
              $('#modalsize').html('Size: ' + fileSize)
              $('#modaldate').html('Date: ' + fileDate)

              var url = '//files/fileinfo.aspx?file=/docs' + filepath;

              $.ajax({
                  url: url,
                  cache: false
              }).done(function (data) {
                  $("#modalfileinfo").html(data);
              });

              $("#modaldelete").click(function () {
                  confirmation(filepath);
              });




              $("#modaldownload").click(function () {
                  document.location = 'getfile.aspx?f=' + filepath;
              });

              $('#myModal').modal('show');
          }



          var plusIcon = "<i class=\"fa fa-plus tree-expand\" aria-hidden=\"true\" />"

          function TreeView(rootElement, openPath) {
              // find all folders with sub folders and add plus arrows for toggling expansion

              if (openPath.length > 1) {
                  openPath = openPath.substring(1, openPath.length);
                  // alert(openPath);
              }

              $(rootElement).find("li").each(function () {
                  if ($(this).children("ul").length > 0) {
                      $(this).prepend(plusIcon);
                      $(this).children(".tree-expand").click(function () {
                          $(this).parent().children("ul").slideToggle("fast", function () {
                              // Animation complete.
                              if ($(this).parent().children("ul").is(":visible")) {
                                  $(this).parent().find("i").first().removeClass("fa-plus").addClass("fa-minus");
                              }
                              else {
                                  $(this).parent().find("i").first().removeClass("fa-minus").addClass("fa-plus");
                                  //$(this).parentsUntil("#treeview").replaceClass('fa-minus', 'fa-plus');
                              }
                          });
                      });


                  }
                  if (openPath.length > 1) {

                      if ($(this).children("a").attr("data") == openPath) {
                          $(this).parentsUntil("#treeview").children("ul").show(0, function () {
                              $(this).parent().find("i").first().removeClass("fa-plus").addClass("fa-minus");
                          });
                      }
                  }
              });

              // add click event to all a tags
              $(rootElement).find("a").each(function () {
                  $(this).click(function () {
                      // alert($(this).attr("data"));
                  });
              });

          }
        TreeView("#treeview", '<%=  HttpUtility.JavaScriptStringEncode(FullUrl) %>');

    </script>

    <style>
        
        .tree-expand{ margin-left: -22px; padding-right:10px; color:#ccc; cursor:pointer;}
        .tree-expand:hover{color:#000;}

        

        #treeview ul{list-style:none; margin:0 0 0 0; padding:0;}
        #treeview ul ul{margin:5px 0 0 20px; display:none;}
        #treeview li{display:block; margin:0 0 5px 10px; width:auto;}
        #treeview ul ul li{margin-left:2px;}
    </style>
    </asp:Content>