<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    string[] AllowedFileExtensions = new string[12] {".jpg", ".jpeg", ".gif", ".png", ".doc", ".docx", ".zip", ".rar", ".pdf", ".xls", ".ppt", ".txt"};
    protected void Page_Load(object sender, EventArgs e)
    {
        LitTypes.Text = GetExtensions();
        if (IsPostBack && Helpers.QueryStringIsNotNull("id") && (Helpers.QueryStringReturnNumber("id") > 0))
        {
            string ErrorMessage = "";
            bool DoSave = false;

            if (Helpers.TextBoxIsNull(DisplayName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your display name.</p>";
            }


            // file upload section
            string FileToSave = "";
            string MIMEType = "";
            HttpFileCollection uploadFilCol = Request.Files;
            if (uploadFilCol.Count < 1)
            {
                DoSave = false;
                ErrorMessage += "<p>Please select your file.</p>";
            }
            for(int i=0;i<uploadFilCol.Count;i++)
            {
                HttpPostedFile file = uploadFilCol[i];



                string fileName = Path.GetFileName(file.FileName);
                if (fileName != string.Empty)
                {
                    string fileExt = Path.GetExtension(file.FileName).ToLower();
                    // cleanup filename
                    string FfileName = fileName.ToLower().Replace(" ", "-");

                    FfileName = Regex.Replace(FfileName, @"[^a-zA-Z0-9_. ]+", "");
                    long fsize = file.ContentLength;
                    MIMEType = fileExt.ToUpper().Replace(".","");

                    if (FfileName.Length > 30) {
                        FfileName = FfileName.Left(30) + "." + fileExt;
                    }

                    if (fsize <= 0)
                    {
                        ErrorMessage = "The selected file has zero size.";
                        DoSave = false;
                    }
                    else
                    {

                        bool AllowedFile = false;
                        foreach (string s in AllowedFileExtensions)
                        {
                            if (fileExt.Equals(s))
                            {
                                AllowedFile = true;
                                break;

                            }


                        }

                        if (!AllowedFile)
                        {
                            ErrorMessage = "The selected file type is now allowed to be added.";
                            DoSave = false;
                        }
                        else
                        {
                            // file is ok, get path to save from part data

                            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                            {
                                conn.Open();
                                using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM View_PartsData WHERE PartPkey = @PartPkey", conn))
                                {
                                    da.SelectCommand.Parameters.AddWithValue("@PartPkey", Helpers.QueryStringReturnNumber("id"));
                                    using (DataTable dt = new DataTable())
                                    {
                                        da.Fill(dt);
                                        if (dt.Rows.Count > 0)
                                        {
                                            string FolderManName = dt.Rows[0]["ManufacturerName"].ToString().DirectoryName();
                                            string FolderPartName = dt.Rows[0]["PartPkey"].ToString().DirectoryName();
                                            // check if directory exists

                                            FileToSave = "\\docs\\" + FolderManName + "\\" + FolderPartName  + "\\" + FfileName;
                                            bool exists = System.IO.Directory.Exists(Server.MapPath("\\docs\\" + FolderManName + "\\" + FolderPartName));

                                            if (!exists)
                                            {
                                                System.IO.Directory.CreateDirectory(Server.MapPath("\\docs\\" + FolderManName + "\\" + FolderPartName));
                                            }
                                            if (System.IO.File.Exists(Server.MapPath(FileToSave)))
                                            {
                                                DoSave = false;
                                                ErrorMessage += "<p>Please enter your display name.</p>";

                                            }
                                            else
                                            {

                                                file.SaveAs(Server.MapPath(FileToSave));
                                                DoSave = true;
                                            }
                                        }

                                    }
                                }
                            }
                        }
                    }
                } else
                {
                    DoSave = false;
                    ErrorMessage += "<p>Please select your file.</p>";
                }
            }
            // end file upload section

            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartAttachment (FileName, DisplayName, MIMEType, DateCreated, PartID) VALUES (@FileName, @DisplayName, @MIMEType, @DateCreated, @PartID)", conn))
                    {
                        cmd.Parameters.AddWithValue("@FileName", FileToSave);
                        cmd.Parameters.AddWithValue("@DisplayName", DisplayName.Text);
                        cmd.Parameters.AddWithValue("@MIMEType", MIMEType);
                        cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
                        cmd.Parameters.AddWithValue("@PartID", Helpers.QueryStringReturnNumber("id"));

                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("done.aspx");
            }
            else
            {
                LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
            }
        }
    }
    public string GetExtensions()
    {
        string vals = "" ;
        foreach (string s in AllowedFileExtensions)
        {
            vals += s + ", ";
        }

        return vals.Trim().Remove(vals.Trim().Length - 1, 1);
    }
</script>

<!DOCTYPE html>
<html lang="en">
<head runat="server">

    <title>Add attachment</title>
    <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="/css/layout.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
        <div class="row mb-3">
             <div class="col-12 "><p>Please select your file to add to your part below. </p>
                 <p>Allowed file types: <asp:Literal ID="LitTypes" runat="server"></asp:Literal></p>

             </div>
        <div class="col-12 ">
           
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                   
          
                    <div class="form-group">
                        <label for="File1">Choose file</label>
                     
                       <input name="File1" type="file" class="form-control form-control-sm" id="File1" runat="server"  accept=".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf" required> 

                         <small id="File1Help" class="form-text text-muted">Maximum file size is 4Mb.</small>

                    </div>
                  
                    <div class="form-group">
                        <label for="<%= DisplayName.ClientID %>">Display Name</label>
                        <asp:TextBox ID="DisplayName" CssClass="form-control form-control-sm" runat="server" MaxLength="250" required></asp:TextBox>
                    </div>

                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save mr-1"></i>Save</button>
                    <!-- end content -->
               </div>
    </div>
               </div>
    </form>
</body>
</html>
