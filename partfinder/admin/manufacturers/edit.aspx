<%@ Page Title="Manufacturers - Edit" Language="C#" MasterPageFile="~/MasterPage.master"  %>

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
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Manufacturer WHERE mpkey = @mpkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@mpkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                ManufacturerName.Text = dt.Rows[0]["ManufacturerName"].ToString();
                                ManufacturerAddress.Text = dt.Rows[0]["ManufacturerAddress"].ToString();
                                ManufacturerURL.Text = dt.Rows[0]["ManufacturerURL"].ToString();
                                ManufacturerPhone.Text = dt.Rows[0]["ManufacturerPhone"].ToString();
                                ManufacturerEmail.Text = dt.Rows[0]["ManufacturerEmail"].ToString();
                                ManufacturerLogo.Text = dt.Rows[0]["ManufacturerLogo"].ToString();
                                ManufacturerComment.Text = dt.Rows[0]["ManufacturerComment"].ToString();
                            }
                            else
                            {
                                Response.Redirect("/error.aspx?mode=notfound");
                            }

                        }
                    }


                    // check if location is used by any parts and disable delete if found.
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Parts WHERE PartManID = @PartManID", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@PartManID", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                PanelDelete.Visible = false;
                                LitDeleteMsg.Text += "<p>This manufacturer has parts assigned and cannot be deleted.</p>";
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

            if (Helpers.TextBoxIsNull(ManufacturerName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter name of your Manufacturer Name.</p>";
            }



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE Manufacturer SET ManufacturerName=@ManufacturerName ,ManufacturerAddress=@ManufacturerAddress, ManufacturerURL=@ManufacturerURL, ManufacturerPhone=@ManufacturerPhone, ManufacturerEmail=@ManufacturerEmail, ManufacturerLogo=@ManufacturerLogo, ManufacturerComment=@ManufacturerComment WHERE mpkey=@mpkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@ManufacturerName", ManufacturerName.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerAddress", ManufacturerAddress.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerURL", ManufacturerURL.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerPhone", ManufacturerPhone.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerEmail", ManufacturerEmail.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerLogo", ManufacturerLogo.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerComment", ManufacturerComment.Text);
                        cmd.Parameters.AddWithValue("@mpkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Helpers.DoLog("Manufacturer Updated:" + ManufacturerName.Text);
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
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Manufacturer WHERE mpkey=@mpkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@mpkey", Helpers.QueryStringReturnNumber("id"));
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
    <li class="breadcrumb-item"><a href="/admin/manufacturers/">Manufacturers</a></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Edit Manufacturer</h4>
                    <a href="default.aspx" title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="row">
                        <div class="col-12 col-md-6">
                            <div class="mb-3 required">
                                <label for="<%= ManufacturerName.ClientID %>">Name</label>
                                <asp:TextBox ID="ManufacturerName" CssClass="form-control form-control-sm" runat="server" placeholder="Enter name" MaxLength="250" required></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="<%= ManufacturerAddress.ClientID %>">Address</label>
                                <asp:TextBox ID="ManufacturerAddress" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="<%= ManufacturerURL.ClientID %>">URL</label>
                                <asp:TextBox ID="ManufacturerURL" CssClass="form-control form-control-sm" runat="server" placeholder="https://" MaxLength="250"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="<%= ManufacturerPhone.ClientID %>">Phone</label>
                                <asp:TextBox ID="ManufacturerPhone" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="<%= ManufacturerEmail.ClientID %>">Email</label>
                                <asp:TextBox ID="ManufacturerEmail" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label for="<%= ManufacturerLogo.ClientID %>">Logo</label>
                                <div class="input-group">

                                    <asp:TextBox ID="ManufacturerLogo" CssClass="form-control " runat="server" MaxLength="250"></asp:TextBox>
                                    <div class="input-group-append">
                                        <a href="javascript:ImageBrowser()" class="input-group-text bg-secondary text-white" id="inputGroupPrepend3"><i class="far fa-folder-open me-2"></i>Open File Browser</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <div class="mb-3">
                                <label for="<%= ManufacturerComment.ClientID %>">Notes</label>
                                <asp:TextBox ID="ManufacturerComment" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="10" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save me-1"></i>Save</button>
                        </div>
                    </div>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-12">
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title text-danger">Delete Manufacturer</h4>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Panel ID="PanelDelete" runat="server">
                        <p>Are you sure you want to delete this item?</p>
                        <a href="edit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true" id="Button2" class="btn btn-danger  btn-sm"><i class="fas fa-save me-1"></i>Delete</a>
                    </asp:Panel>
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
            window.open('/admin/filebrowser.aspx?fn=form1&fieldname=<%= ManufacturerLogo.ClientID %>', 'mywindow', 'location=1,status=1,scrollbars=1, width=600,height=600');
        }
    </script>
</asp:Content>