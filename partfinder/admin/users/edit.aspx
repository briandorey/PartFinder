<%@ Page Title="Users - Edit" Language="C#" MasterPageFile="~/MasterPage.master"  %>

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
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Users WHERE UserPkey = @UserPkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@UserPkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0) {
                                EmailAddress.Text = dt.Rows[0]["Username"].ToString();
                                UserPass.Text = dt.Rows[0]["UserPass"].ToString();
                            }
                            else
                            {
                                Response.Redirect("/error.aspx?mode=notfound");
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

            if (Helpers.TextBoxIsNull(EmailAddress))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your email address.</p>";
            }

            if (Helpers.TextBoxIsEmail(EmailAddress))
            {
                DoSave = false;
                ErrorMessage += "<p>Your email address is not in the correct format.</p>";
            }

            if (Helpers.TextBoxIsNull(UserPass))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your password.</p>";
            }
            if (Helpers.TextBoxIsNull(UserPass2))
            {
                DoSave = false;
                ErrorMessage += "<p>Please confirm your password.</p>";
            }

            if (UserPass2.Text != UserPass.Text)
            {
                DoSave = false;
                ErrorMessage += "<p>Your passwords do not match.</p>";
            }



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    Secure sec = new Secure();
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE Users SET Username=@Username ,UserPass=@UserPass WHERE UserPkey=@UserPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", EmailAddress.Text);
                        cmd.Parameters.AddWithValue("@UserPass", sec.ComputeSha256Hash(UserPass.Text.ToString()));
                        cmd.Parameters.AddWithValue("@UserPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
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
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Users WHERE UserPkey=@UserPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserPkey", Helpers.QueryStringReturnNumber("id"));
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
    <li class="breadcrumb-item"><a href="/admin/users/">Users</a></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
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
   <div class="mb-3 required">
    <label for="<%= EmailAddress.ClientID %>">Email address</label>
       <asp:TextBox ID="EmailAddress" CssClass="form-control form-control-sm" runat="server" placeholder="Enter email" MaxLength="50" required></asp:TextBox>
    </div>
    <div class="mb-3 required">
    <label for="<%= UserPass.ClientID %>">Password</label>
       <asp:TextBox ID="UserPass" TextMode="Password" CssClass="form-control form-control-sm" runat="server" placeholder="Enter password" MaxLength="250" required></asp:TextBox>
    </div>
    <div class="mb-3 required">
    <label for="<%= UserPass2.ClientID %>">Confirm Password</label>
       <asp:TextBox ID="UserPass2" TextMode="Password" CssClass="form-control form-control-sm" runat="server" placeholder="Confirm password" required></asp:TextBox>
    </div>
    <button runat="server" ID="Button1" class="btn btn-primary "><i class="fas fa-save me-1"></i> Save</button>
                     <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
   
            <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                 <h4 class="card-title text-danger">Delete User</h4>
                 
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <p>Are you sure you want to delete this user?</p>
                     <a href="edit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true"  ID="Button2" class="btn btn-danger  btn-sm"><i class="fas fa-save me-1"></i> Delete</a>
                    <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
  </asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" Runat="Server">

   
</asp:Content>