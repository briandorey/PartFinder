<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;


            if (Helpers.TextBoxIsNull(ParamName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your Parameter Name.</p>";

            }
            if (Helpers.TextBoxIsNull(ParamValue))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your Parameter Value.</p>";

            }


            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartParameter (ParamName, ParamValue, PartID) VALUES (@ParamName, @ParamValue, @PartID)", conn))
                    {
                        cmd.Parameters.AddWithValue("@ParamName", ParamName.Text);
                        cmd.Parameters.AddWithValue("@ParamValue", ParamValue.Text);
                        cmd.Parameters.AddWithValue("@PartID", Helpers.QueryStringReturnNumber("id"));

                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("done.aspx");
            }
            else
            {
                LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
            }
        }
    }
</script>

<!DOCTYPE html>
<html lang="en">
<head runat="server">

    <title></title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="/css/layout.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row mb-3">
                <div class="col-12 ">

                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>

                    <div class="form-group">
                        <label for="<%= ParamName.ClientID %>">Name </label>
                        <asp:TextBox ID="ParamName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>

                    </div>
                   
                    <div class="form-group">
                        <label for="<%= ParamValue.ClientID %>">Value</label>
                        <asp:TextBox ID="ParamValue" CssClass="form-control form-control-sm" runat="server" MaxLength="50" required></asp:TextBox>
                    </div>
                   


                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save mr-1"></i>Save</button>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </form>
</body>
</html>
