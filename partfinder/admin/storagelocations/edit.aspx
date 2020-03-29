<%@ Page Title="Storage Location - Edit" Language="C#" MasterPageFile="~/MasterPage.master"  %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM StorageLocation WHERE StoragePkey = @StoragePkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@StoragePkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                StorageName.Text = dt.Rows[0]["StorageName"].ToString();
                                StorageSortOrder.Text = dt.Rows[0]["StorageSortOrder"].ToString();
                            }
                            else
                            {
                                Response.Redirect("/error.aspx?mode=notfound");
                            }

                        }
                    }


                    // check if location is used by any parts and disable delete if found.
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Parts WHERE StorageLocationID = @StorageLocationID", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@StorageLocationID", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                PanelDelete.Visible = false;
                                LitDeleteMsg.Text += "<p>This storage location has parts assigned and cannot be deleted.</p>";
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
                    using (SqlCommand cmd = new SqlCommand("UPDATE StorageLocation SET StorageName=@StorageName, StorageSortOrder=@StorageSortOrder WHERE StoragePkey=@StoragePkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@StorageName", StorageName.Text);
                        cmd.Parameters.AddWithValue("@StorageSortOrder", StorageSortOrder.Text);
                        cmd.Parameters.AddWithValue("@StoragePkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("default.aspx?mode=update");
            }
            else
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
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM StorageLocation WHERE StoragePkey=@StoragePkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@StoragePkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("default.aspx?mode=delete");
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item"><a href="/admin/storagelocations/">Storage Locations</a></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Edit User</h4>
                    <a href="default.aspx" title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="form-group required">
                        <label for="<%= StorageName.ClientID %>">Name</label>
                        <asp:TextBox ID="StorageName" CssClass="form-control form-control-sm" runat="server" placeholder="Enter name" MaxLength="50" required></asp:TextBox>
                    </div>
                   <div class="form-group required">
                        <label for="<%= StorageSortOrder.ClientID %>">Sort Order</label>
                        <asp:TextBox ID="StorageSortOrder" CssClass="form-control form-control-sm" runat="server" placeholder="0" MaxLength="10" required></asp:TextBox>
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
                    <h4 class="card-title text-danger">Delete Location</h4>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Panel ID="PanelDelete" runat="server">
                        <p>Are you sure you want to delete this item?</p>
                        <a href="edit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true" id="Button2" class="btn btn-danger  btn-sm"><i class="fas fa-save mr-1"></i>Delete</a>
                    </asp:Panel>
                    <asp:Literal ID="LitDeleteMsg" runat="server"></asp:Literal>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
</asp:Content>
