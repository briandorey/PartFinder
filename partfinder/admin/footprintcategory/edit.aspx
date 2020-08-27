<%@ Page Title="Footprint Categories - Edit" Language="C#" MasterPageFile="~/MasterPage.master"  %>

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
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM FootprintCategory WHERE FCPkey = @FCPkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@FCPkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0) {
                                FCName.Text = dt.Rows[0]["FCName"].ToString();
                                FCDescription.Text = dt.Rows[0]["FCDescription"].ToString();
                               FootprintCategoryHelpers nav = new FootprintCategoryHelpers();
                                nav.LoadFootprintMenu(ParentCategory, true);


                                ParentCategory.SelectedIndex = ParentCategory.Items.IndexOf(ParentCategory.Items.FindByValue(dt.Rows[0]["ParentCategory"].ToString()));
                            }
                            else
                            {
                                Response.Redirect("/error.aspx?mode=notfound");
                            }

                        }
                    }

                    // check if category has items or sub categories and disable delete panel if true.

                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT ParentCategory FROM FootprintCategory WHERE ParentCategory = @ParentCategory", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@ParentCategory", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                 PanelDelete.Visible = false;
                                LitDeleteMsg.Text += "<p>This category has sub categories and cannot be deleted.</p>";
                            }
                        }
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT FootprintCategory FROM Footprint WHERE FootprintCategory = @FootprintCategory", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@FootprintCategory", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                 PanelDelete.Visible = false;
                                LitDeleteMsg.Text += "<p>This category has footprints and cannot be deleted.</p>";
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

            if (Helpers.TextBoxIsNull(FCName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your category name.</p>";
            }



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE FootprintCategory SET ParentCategory=@ParentCategory, FCName=@FCName ,FCDescription=@FCDescription WHERE FCPkey=@FCPkey", conn))
                    {

                        cmd.Parameters.AddWithValue("@ParentCategory", ParentCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@FCName", FCName.Text);
                        cmd.Parameters.AddWithValue("@FCDescription", FCDescription.Text);
                        cmd.Parameters.AddWithValue("@FCPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Helpers.DoLog("Footprint Category Updated:" + FCName.Text);
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
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM FootprintCategory WHERE FCPkey=@FCPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@FCPkey", Helpers.QueryStringReturnNumber("id"));
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
    <li class="breadcrumb-item"><a href="/admin/footprintcategory/">Footprint Category</a></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Edit Footprint Category</h4>
                   <a href="default.aspx"  title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body" >
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="form-group required">
                        <label for="DefaultCountry">Parent Category</label>
                        <asp:DropDownList CssClass="form-control form-control-sm" ID="ParentCategory" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group required">
                        <label for="<%= FCName.ClientID %>">Name</label>
                        <asp:TextBox ID="FCName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>
                        <small id="FCNameHelp" class="form-text text-muted">The Categories are sorted by alphabetical order on the menus and website.</small>
                        
                    </div>
                    <div class="form-group">
                        <label for="<%= FCDescription.ClientID %>">Description</label>
                        <asp:TextBox ID="FCDescription" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
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
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" Runat="Server">

   
</asp:Content>