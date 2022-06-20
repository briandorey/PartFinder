<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">


    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void ButtonAddUser_Click(object sender, EventArgs e)
    {
        // Add new user
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
            Secure sec = new Secure();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Users (Username,UserPass) VALUES (@Username,@UserPass)", conn))
                {
                    cmd.Parameters.AddWithValue("@Username", EmailAddress.Text);
                    cmd.Parameters.AddWithValue("@UserPass", sec.ComputeSha256Hash(UserPass.Text.ToString()));
                    cmd.ExecuteNonQuery();
                }
            }
            LitError.Text = "<div class=\"alert alert-success\" role=\"alert\">Your new user account has been added</div>";
           
        }
        else
        {
            LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
        }
    }

</script>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="author" content="Brian Dorey www.briandorey.com">
    <title>Part Finder Setup</title>
    <link href="/css/layout.min.css" rel="stylesheet">
    <link href="/css/all.min.css" rel="stylesheet" type="text/css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row">
                <div class="col-12 pb-4 text-center">
                    <h1 class="display-4">Part Finder Setup</h1>
                    <p>This page allows you to create your first user account to sign into Part Finder.</p>
                    <p>Delete the setup folder once setup is completed.</p>
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                </div>
            </div>
            <asp:Panel ID="PanelUserContainer" runat="server">
                <div class="row p-3 border rounded bg-light mb-3">
                    <div class="col-12">
                        <h2>Step 1 - Add User</h2>
                        <p>Add a user account to access Part Finder</p>
                        <div class="mb-3">
                            <label for="<%= EmailAddress.ClientID %>">Email address</label>
                            <asp:TextBox ID="EmailAddress" runat="server" CssClass="form-control" MaxLength="50" placeholder="Enter email"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="<%= UserPass.ClientID %>">Password</label>
                            <asp:TextBox ID="UserPass" runat="server" CssClass="form-control" MaxLength="50" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="<%= UserPass2.ClientID %>">Confirm Password</label>
                            <asp:TextBox ID="UserPass2" runat="server" CssClass="form-control" MaxLength="50" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                        </div>
                        <asp:Button ID="ButtonAddUser" runat="server" Text="Add User" CssClass="btn btn-primary" OnClick="ButtonAddUser_Click" />

                    </div>
                </div>
            </asp:Panel>
            
        </div>
    </form>
</body>
</html>