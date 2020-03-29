<%@ Page Title="Manufacturers - Add" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
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
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Manufacturer (ManufacturerName, ManufacturerAddress, ManufacturerURL, ManufacturerPhone, ManufacturerEmail, ManufacturerLogo, ManufacturerComment) VALUES (@ManufacturerName, @ManufacturerAddress, @ManufacturerURL, @ManufacturerPhone, @ManufacturerEmail, @ManufacturerLogo, @ManufacturerComment)", conn))
                    {
                        cmd.Parameters.AddWithValue("@ManufacturerName", ManufacturerName.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerAddress", ManufacturerAddress.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerURL", ManufacturerURL.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerPhone", ManufacturerPhone.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerEmail", ManufacturerEmail.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerLogo", ManufacturerLogo.Text);
                        cmd.Parameters.AddWithValue("@ManufacturerComment", ManufacturerComment.Text);

                        cmd.ExecuteNonQuery();
                    }
                    System.IO.Directory.CreateDirectory(@Server.MapPath("\\docs\\" + ManufacturerName.Text.ToString().DirectoryName()));
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
    <li class="breadcrumb-item"><a href="/admin/manufacturers/">Manufacturers</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Manufacturer</h4>
                    <a href="default.aspx"  title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="row">
                        <div class="col-12 col-md-6">
                             <div class="form-group required">
                        <label for="<%= ManufacturerName.ClientID %>">Name</label>
                        <asp:TextBox ID="ManufacturerName" CssClass="form-control form-control-sm" runat="server" placeholder="Enter name" MaxLength="250" required></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%= ManufacturerAddress.ClientID %>">Address</label>
                        <asp:TextBox ID="ManufacturerAddress" CssClass="form-control form-control-sm" runat="server"  MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%= ManufacturerURL.ClientID %>">URL</label>
                        <asp:TextBox ID="ManufacturerURL" CssClass="form-control form-control-sm" runat="server" placeholder="https://" MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%= ManufacturerPhone.ClientID %>">Phone</label>
                        <asp:TextBox ID="ManufacturerPhone" CssClass="form-control form-control-sm" runat="server"  MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%= ManufacturerEmail.ClientID %>">Email</label>
                        <asp:TextBox ID="ManufacturerEmail" CssClass="form-control form-control-sm" runat="server"  MaxLength="250"></asp:TextBox>
                    </div>
                   
                     <div class="form-group">
                        <label for="<%= ManufacturerLogo.ClientID %>">Logo</label>
                        <div class="input-group">

                            <asp:TextBox ID="ManufacturerLogo" CssClass="form-control" runat="server" MaxLength="250"></asp:TextBox>
                            <div class="input-group-append">
                                <a href="javascript:ImageBrowser()" class="input-group-text bg-secondary text-white" id="inputGroupPrepend3"><i class="far fa-folder-open mr-2"></i>Open File Browser</a>
                            </div>
                        </div>
                    </div>
                        </div>
                        <div class="col-12 col-md-6">
 <div class="form-group">
                        <label for="<%= ManufacturerComment.ClientID %>">Notes</label>
                        <asp:TextBox ID="ManufacturerComment" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="10" runat="server" ></asp:TextBox>
                    </div>
                        </div>
                    </div>
                   <div class="row">
                       <div class="col-12"><button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save mr-1"></i>Save</button></div>

                   </div>
                   
                  

                    
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
