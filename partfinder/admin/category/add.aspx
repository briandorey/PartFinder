<%@ Page Title="Categories - Add" Language="C#" MasterPageFile="~/MasterPage.master"  %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CategoryHelpers nav = new CategoryHelpers();
            string index = "0";
            if (Helpers.QueryStringIsNotNull("parent"))
            {
                index = Helpers.QueryStringReturnNumber("parent").ToString();
            }
            nav.LoadCatMenu(ParentID, index);



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
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartCategory (ParentID, PCName,PCDescription) VALUES (@ParentID, @PCName,@PCDescription)", conn))
                    {
                        cmd.Parameters.AddWithValue("@ParentID", ParentID.SelectedValue);
                        cmd.Parameters.AddWithValue("@PCName", PCName.Text);
                        cmd.Parameters.AddWithValue("@PCDescription", PCDescription.Text);
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("treeview.aspx?mode=add");
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
    <li class="breadcrumb-item"><a href="/admin/category/treeview.aspx">Category</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Category</h4>
                    <a href="default.aspx" title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body p-3">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="form-group required">
                        <label for="DefaultCountry">Parent Category</label>
                        <asp:DropDownList CssClass="form-control form-control-sm" ID="ParentID" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group required">
                        <label for="<%= PCName.ClientID %>">Category</label>
                        <asp:TextBox ID="PCName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>
                        <small id="PCNameHelp" class="form-text text-muted">The Categories are sorted by alphabetical order on the menus and website.</small>
                    </div>
                    <div class="form-group">
                        <label for="<%= PCDescription.ClientID %>">Description</label>
                        <asp:TextBox ID="PCDescription" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
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
