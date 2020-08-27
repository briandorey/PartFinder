<%@ Page Title="Footprint Categories - Add" Language="C#" MasterPageFile="~/MasterPage.master"  %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FootprintCategoryHelpers nav = new FootprintCategoryHelpers();
            nav.LoadFootprintMenu(ParentCategory, true);

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
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO FootprintCategory (ParentCategory, FCName,FCDescription) VALUES (@ParentCategory, @FCName,@FCDescription)", conn))
                    {
                        cmd.Parameters.AddWithValue("@ParentCategory", ParentCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@FCName", FCName.Text);
                        cmd.Parameters.AddWithValue("@FCDescription", FCDescription.Text);
                        cmd.ExecuteNonQuery();
                    }
                }
                Helpers.DoLog("Footprint Category Added:" + FCName.Text);
                Response.Redirect("default.aspx?mode=add");
            }
            else
            {
                LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item"><a href="/admin/footprintcategory/">Footprint Category</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Footprint Category</h4>
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
                        <label for="<%= FCName.ClientID %>">Name</label>
                        <asp:TextBox ID="FCName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>
                        <small id="FCNameHelp" class="form-text text-muted">The Footprint Categories are sorted by alphabetical order on the menus and website.</small>
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
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
</asp:Content>
