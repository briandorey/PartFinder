<%@ Page Title="Storage Locations - Add" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;

            if (Helpers.TextBoxIsNull(StorageName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter name of your storage location.</p>";
            }

            if (Helpers.TextBoxIsNull(StorageSortOrder))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter the sort order of your storage location.</p>";
            }

            if (!Helpers.TextBoxIsInt(StorageSortOrder))
            {
                DoSave = false;
                ErrorMessage += "<p>The sort order must be a number.</p>";
            }
            
            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO StorageLocation (StorageName, StorageSortOrder) VALUES (@StorageName, @StorageSortOrder)", conn))
                    {
                        cmd.Parameters.AddWithValue("@StorageName", StorageName.Text);
                       cmd.Parameters.AddWithValue("@StorageSortOrder", StorageSortOrder.Text);
                        cmd.ExecuteNonQuery();
                    }
                }
                Helpers.DoLog("Storage Location Added:" + StorageName.Text);
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
    <li class="breadcrumb-item"><a href="/admin/storagelocations/">Storage Locations</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card shadow mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Storage Location</h4>
                    <div>
                    <a href="addgrid.aspx" title="Add Grid"><i class="fas fa-th me-3"></i></a>
                    <a href="default.aspx" title="List View"><i class="fas fa-list"></i></a></div>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="mb-3 required">
                        <label for="<%= StorageName.ClientID %>">Name</label>
                        <asp:TextBox ID="StorageName" CssClass="form-control form-control-sm" runat="server" placeholder="Enter name" MaxLength="50" required></asp:TextBox>
                    </div>
                    <div class="mb-3 required">
                        <label for="<%= StorageSortOrder.ClientID %>">Sort Order</label>
                        <asp:TextBox ID="StorageSortOrder" CssClass="form-control form-control-sm" runat="server" placeholder="0" MaxLength="10" required></asp:TextBox>
                    </div>
                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save me-1"></i>Save</button>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </div>


</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
</asp:Content>
