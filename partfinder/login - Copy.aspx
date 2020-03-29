<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    // uses users table from database and encryption for password field

    protected void Page_Load(object sender, EventArgs e)
    {
               if (Request.QueryString["signout"] != null)
        {
            FormsAuthentication.SignOut();
        }
        if (IsPostBack)
        {
            if (ValidateUser(InputEmail.Text, InputPassword.Text))
            {
                bool rememberMe = CheckBoxRemember.Checked; 
                FormsAuthentication.RedirectFromLoginPage(InputEmail.Text, rememberMe);
            }
            else
            {
               LitError.Text = "<div class=\"alert alert-danger mt-3\" role=\"alert\">Please sign in to continue</div>";
            }
        }
    }

    private bool ValidateUser(string userName, string passWord)
    {
        string lookupPassword = null;
        // Check for invalid userName. userName must not be null
        if ((null == userName) || (0 == userName.Length))
        {

            return false;
        }

        // Check for invalid passWord. passWord must not be null 
        if ((null == passWord) || (0 == passWord.Length))
        {
            return false;
        }

        try
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("Select UserPass from users where Username=@Username", conn))
                {
                    cmd.Parameters.Add("@Username", SqlDbType.VarChar, 50);
                    cmd.Parameters["@Username"].Value = userName;
                    lookupPassword = (string)cmd.ExecuteScalar();
                }

            }
        }
        catch (Exception e)
        {
            
        }

        // If no password found, return false.
        if (null == lookupPassword)
        {
            return false;
        }
        Secure sec = new Secure();
        return (0 == string.Compare(lookupPassword, sec.ComputeSha256Hash(passWord), false));
    }
</script>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Part Finder - Sign In</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link href="/css/layout.css" rel="stylesheet" />
    <style>
        html,
        body {
            height: 100%;
        }

        body {
            display: -ms-flexbox;
            display: -webkit-box;
            display: flex;
            -ms-flex-align: center;
            -ms-flex-pack: center;
            -webkit-box-align: center;
            align-items: center;
            -webkit-box-pack: center;
            justify-content: center;
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }

        .form-signin {
            width: 100%;
            max-width: 330px;
            padding: 15px;
            margin: 0 auto;
        }

            .form-signin .checkbox {
                font-weight: 400;
            }

            .form-signin .form-control {
                position: relative;
                box-sizing: border-box;
                height: auto;
                padding: 10px;
                font-size: 16px;
                margin-bottom: 5px;
            }

                .form-signin .form-control:focus {
                    z-index: 2;
                }

            .form-signin input[type="email"] {
                margin-bottom: -1px;
                border-bottom-right-radius: 0;
                border-bottom-left-radius: 0;
            }

            .form-signin input[type="password"] {
                margin-bottom: 10px;
                border-top-left-radius: 0;
                border-top-right-radius: 0;
            }

        .checkbox .btn,
        .checkbox-inline .btn {
            padding-left: 2em;
            min-width: 8em;
        }



        .checkbox label,
        .checkbox-inline label {
            text-align: left;
            padding-left: 0.5em;
        }
    </style>
</head>
<body class="text-center">
    <form id="form1" runat="server" class="form-signin">
        <h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>
        <label for="<%= InputEmail.ClientID %>" class="sr-only">Email address</label>
        <asp:TextBox ID="InputEmail" runat="server" CssClass="form-control form-control-sm" placeholder="Email address" required></asp:TextBox>
        <label for="<%= InputPassword.ClientID %>" class="sr-only">Password</label>
        <asp:TextBox ID="InputPassword" runat="server" TextMode="Password" CssClass="form-control form-control-sm" required placeholder="Password"></asp:TextBox>
        <div class="form-group">
            <div class="checkbox">
                <label class="btn btn-default">
                    <asp:CheckBox ID="CheckBoxRemember" runat="server" Text="Remember me" />
                </label>
            </div>
        </div>
        <asp:Button ID="Button1" CssClass="btn btn-lg btn-primary btn-block" runat="server" Text="Sign in" />
        <asp:Literal ID="LitError" runat="server"></asp:Literal>
    </form>
</body>
</html>
