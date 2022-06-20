<%@ Page Title="Categories - Edit" Language="C#" MasterPageFile="~/MasterPage.master"  %>

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
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PartCategory WHERE PCpkey = @PCpkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@PCpkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0) {
                                PCName.Text = dt.Rows[0]["PCName"].ToString();
                                PCDescription.Text = dt.Rows[0]["PCDescription"].ToString();
                                CategoryHelpers nav = new CategoryHelpers();
                                nav.LoadCatMenu(ParentID);


                                ParentID.SelectedIndex = ParentID.Items.IndexOf(ParentID.Items.FindByValue(dt.Rows[0]["ParentID"].ToString()));
                            }
                            else
                            {
                                Response.Redirect("/error.aspx?mode=notfound");
                            }

                        }
                    }

                    // check if category has items or sub categories and disable delete panel if true.

                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT ParentID FROM PartCategory WHERE ParentID = @ParentID", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@ParentID", pkey);
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
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Parts WHERE PartCategoryID = @PartCategoryID", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@PartCategoryID", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                 PanelDelete.Visible = false;
                                LitDeleteMsg.Text += "<p>This category has parts assigned and cannot be deleted.</p>";
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

            if (Helpers.TextBoxIsNull(PCName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your category name.</p>";
            }



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE PartCategory SET ParentID=@ParentID, PCName=@PCName ,PCDescription=@PCDescription WHERE PCpkey=@PCpkey", conn))
                    {

                        cmd.Parameters.AddWithValue("@ParentID", ParentID.SelectedValue);
                        cmd.Parameters.AddWithValue("@PCName", PCName.Text);
                        cmd.Parameters.AddWithValue("@PCDescription", PCDescription.Text);
                        cmd.Parameters.AddWithValue("@PCpkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Helpers.DoLog("Category Updated:" + PCName.Text);
                Response.Redirect("treeview.aspx?mode=update");
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
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartCategory WHERE PCpkey=@PCpkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@PCpkey", Helpers.QueryStringReturnNumber("id"));
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
    <li class="breadcrumb-item"><a href="/admin/category/">Category</a></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header  d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Edit Category</h4>
                   <a href="default.aspx" title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="mb-3 required">
                        <label for="DefaultCountry">Parent Category</label>
                        <asp:DropDownList CssClass="form-control form-control-sm" ID="ParentID" runat="server"></asp:DropDownList>
                    </div>
                    <div class="mb-3 required">
                        <label for="<%= PCName.ClientID %>">Category</label>
                        <asp:TextBox ID="PCName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>
                        <small id="PCNameHelp" class="form-text text-muted">The Categories are sorted by alphabetical order on the menus and website.</small>
                        
                    </div>
                    <div class="mb-3">
                        <label for="<%= PCDescription.ClientID %>">Description</label>
                        <asp:TextBox ID="PCDescription" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                    </div>

                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save me-1"></i>Save</button>
                     <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
    
            <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title text-danger">Delete Category</h4>
                 
                </div>
                <div class="card-body ">
                    <!-- start content --><asp:Panel ID="PanelDelete" runat="server">
                    <p>Are you sure you want to delete this item?</p>
                     <a href="edit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true"  ID="Button2" class="btn btn-danger  btn-sm"><i class="fas fa-save me-1"></i> Delete</a></asp:Panel>
                    <asp:Literal ID="LitDeleteMsg" runat="server"></asp:Literal>
                    <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
      
  </asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" Runat="Server">

   
</asp:Content>