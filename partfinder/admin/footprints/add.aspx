<%@ Page Title="Footprints - Add" Language="C#" MasterPageFile="~/MasterPage.master"  %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FootprintCategoryHelpers nav = new FootprintCategoryHelpers();
            nav.LoadFootprintMenu(ParentCategory, false);

        }
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;


            if (Helpers.TextBoxIsNull(FootprintName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your footprint name.</p>";
            }


            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Footprint (FootprintCategory, FootprintName,FootprintDescription, FootprintImage) VALUES (@FootprintCategory, @FootprintName,@FootprintDescription, @FootprintImage)", conn))
                    {
                        cmd.Parameters.AddWithValue("@FootprintCategory", ParentCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@FootprintName", FootprintName.Text);
                        cmd.Parameters.AddWithValue("@FootprintDescription", FootprintDescription.Text);
                        cmd.Parameters.AddWithValue("@FootprintImage", FootprintImage.Text);

                        cmd.ExecuteNonQuery();
                    }
                }
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
    <li class="breadcrumb-item"><a href="/admin/footprints/">Footprints</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Footprint</h4>
                    <a href="default.aspx"  title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body p-3">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="form-group required">
                        <label for="DefaultCountry">Category</label>
                        <asp:DropDownList CssClass="form-control form-control-sm" ID="ParentCategory" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group required">
                        <label for="<%= FootprintName.ClientID %>">Name</label>
                        <asp:TextBox ID="FootprintName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>

                    </div>
                    <div class="form-group">
                        <label for="<%= FootprintDescription.ClientID %>">Description</label>
                        <asp:TextBox ID="FootprintDescription" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%= FootprintImage.ClientID %>">Image</label>
                        <div class="input-group">

                            <asp:TextBox ID="FootprintImage" CssClass="form-control" runat="server" MaxLength="250"></asp:TextBox>
                            <div class="input-group-append input-group-sm ">
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
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">

    <script>
        function ImageBrowser() {
            window.open('/admin/filebrowser.aspx?fn=form1&fieldname=<%= FootprintImage.ClientID %>', 'mywindow', 'location=1,status=1,scrollbars=1, width=600,height=600');
        }
    </script>
</asp:Content>
