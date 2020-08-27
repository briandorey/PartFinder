<%@ Page Title="Footprints - Edit" Language="C#" MasterPageFile="~/MasterPage.master"  %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack) {
            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Footprint WHERE FootprintPkey = @FootprintPkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@FootprintPkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0) {
                                FootprintName.Text = dt.Rows[0]["FootprintName"].ToString();
                                FootprintDescription.Text = dt.Rows[0]["FootprintDescription"].ToString();
                                FootprintImage.Text = dt.Rows[0]["FootprintImage"].ToString();
                               FootprintCategoryHelpers nav = new FootprintCategoryHelpers();
                                nav.LoadFootprintMenu(ParentCategory, false);


                                ParentCategory.SelectedIndex = ParentCategory.Items.IndexOf(ParentCategory.Items.FindByValue(dt.Rows[0]["FootprintCategory"].ToString()));
                            }
                            else
                            {
                                Response.Redirect("/error.aspx?mode=notfound");
                            }

                        }
                    }

                    // check if item has parts and disable delete panel if true.

                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT PartFootprintID FROM Parts WHERE PartFootprintID = @PartFootprintID", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@PartFootprintID", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                 PanelDelete.Visible = false;
                                LitDeleteMsg.Text += "<p>This footprint is used by current parts and cannot be deleted.</p>";
                            }
                        }
                    }

                  
                    
                    
                }
            }
            else
            {
                Response.Redirect("/error.aspx?mode=idnotfound");
            }
        }
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;

            if (Helpers.TextBoxIsNull(FootprintName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your category name.</p>";
            }



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE Footprint SET FootprintCategory=@FootprintCategory, FootprintName=@FootprintName ,FootprintDescription=@FootprintDescription, FootprintImage=@FootprintImage WHERE FootprintPkey=@FootprintPkey", conn))
                    {

                        cmd.Parameters.AddWithValue("@FootprintCategory", ParentCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@FootprintName", FootprintName.Text);
                        cmd.Parameters.AddWithValue("@FootprintDescription", FootprintDescription.Text);
                        cmd.Parameters.AddWithValue("@FootprintImage", FootprintImage.Text);
                        cmd.Parameters.AddWithValue("@FootprintPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Helpers.DoLog("Footprint Updated:" + FootprintName.Text);
                Response.Redirect("default.aspx?mode=update");
            } else
            {
                LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
            }
        }

        if (Request.QueryString["delete"] != null)
        {
            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Footprint WHERE FootprintPkey=@FootprintPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@FootprintPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("default.aspx?mode=delete");
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
   <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item"><a href="/admin/footprints/">Footprints</a></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Edit Footprint</h4>
                   <a href="default.aspx"  title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="form-group required">
                        <label for="DefaultCountry">Parent Category</label>
                        <asp:DropDownList CssClass="form-control form-control-sm" ID="ParentCategory" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group required">
                        <label for="<%= FootprintName.ClientID %>">Name</label>
                        <asp:TextBox ID="FootprintName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>
                        <small id="FootprintNameHelp" class="form-text text-muted">The Categories are sorted by alphabetical order on the menus and website.</small>
                        
                    </div>
                    <div class="form-group">
                        <label for="<%= FootprintDescription.ClientID %>">Description</label>
                        <asp:TextBox ID="FootprintDescription" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%= FootprintImage.ClientID %>">Image</label>
                        <div class="input-group">

                            <asp:TextBox ID="FootprintImage" CssClass="form-control" runat="server" MaxLength="250"></asp:TextBox>
                            <div class="input-group-append">
                                <a href="javascript:ImageBrowser()" class="input-group-text bg-secondary text-white" id="inputGroupPrepend3"><i class="far fa-folder-open mr-2"></i>Open File Browser</a>
                            </div>
                        </div>
                    </div>
                    
                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save mr-1"></i>Save</button>
                     <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
    
            <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title text-danger">Delete Footprint Category</h4>
                 
                </div>
                <div class="card-body">
                    <!-- start content --><asp:Panel ID="PanelDelete" runat="server">
                    <p>Are you sure you want to delete this item?</p>
                     <a href="edit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true"  ID="Button2" class="btn btn-danger  btn-sm"><i class="fas fa-save mr-1"></i> Delete</a></asp:Panel>
                    <asp:Literal ID="LitDeleteMsg" runat="server"></asp:Literal>
                    <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
      
  </asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">

    <script>
        function ImageBrowser() {
            window.open('/admin/filebrowser.aspx?fn=form1&fieldname=<%= FootprintImage.ClientID %>', 'mywindow', 'location=1,status=1,scrollbars=1, width=600,height=600');
        }
    </script>
</asp:Content>