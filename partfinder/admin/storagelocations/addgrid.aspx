<%@ Page Title="Storage Locations - Add Grid" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    public int rowcounter = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        Literal1.Text = "";

        if (!IsPostBack)
        {
            for (int i = 1; i < 27; i++)
            {
                GridColumns.Items.Add(i.ToString());
            }
        }
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;
            int NumRows = 0;

            if (Helpers.TextBoxIsNull(GridRows))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter number of rows required.</p>";
            }

            if (Helpers.TextBoxIsInt(GridRows))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter number of rows required as a number.</p>";
            } else
            {
                NumRows = Int32.Parse(GridRows.Text.ToString());
            }
            int NumColumns = Int32.Parse(GridColumns.SelectedValue.ToString());



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    for (int c = 1; c <= NumColumns; c++)
                    {
                        for (int r = 1; r <= NumRows; r++)
                        {
                            if (PrefixName.Text.Length > 0)
                            {
                                AddRow(PrefixName.Text.ToString().CleanString() + ((char)(c + 64)).ToString() + r.ToString(), conn);
                            }
                            else
                            {
                                AddRow(((char)(c + 64)).ToString() + r.ToString(), conn);
                            }
                        }
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
    private void AddRow(string val, SqlConnection conn)
    {

        using (SqlCommand cmd = new SqlCommand("INSERT INTO StorageLocation (StorageName, StorageSortOrder) VALUES (@StorageName, @StorageSortOrder)", conn))
        {
            cmd.Parameters.AddWithValue("@StorageName", val);
            cmd.Parameters.AddWithValue("@StorageSortOrder", rowcounter);
            cmd.ExecuteNonQuery();
        }
        rowcounter = rowcounter + 1;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item"><a href="/admin/storagelocations/">Storage Locations</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add Grid</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Literal ID="Literal1" runat="server"></asp:Literal>
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card shadow mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Storage Location Grid</h4>
                    <a href="default.aspx" title="List View"><i class="fas fa-list"></i></a>
                </div>
                <div class="card-body">
                    <p>This page allows you to quickly create a grid of folder locations in the format "prefixA1" using the number of rows and columns you require.</p>
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="mb-3 required">
                        <label for="<%= PrefixName.ClientID %>">Prefix:</label>
                        <asp:TextBox ID="PrefixName" CssClass="form-control form-control-sm" runat="server" placeholder="tray-" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="mb-3 required">
                        <label for="<%= GridColumns.ClientID %>">Number of Columns:</label>
                        <asp:DropDownList ID="GridColumns" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>
                    </div>
                    <div class="mb-3 required">
                        <label for="<%= GridRows.ClientID %>">Number of Rows:</label>
                        <asp:TextBox ID="GridRows" CssClass="form-control form-control-sm" runat="server" Text="5" MaxLength="50" required></asp:TextBox>
                        <small id="GridRowsXHelp" class="form-text text-muted">Must contain a number between 1 and 100.</small>
                       
                    </div>

                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save me-1"></i>Generate Storage Locations</button>
                    <div class="alert alert-success mt-3" role="alert" id="AlertMessage">
  Please select the number of columns you require and enter the number of rows.
</div>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </div>


</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
    <script>
        $('#<%= GridColumns.ClientID %>').on("input", function () {
            CalcLocations();
        });
        $('#<%= GridRows.ClientID %>').on("input", function () {
            CalcLocations();
        });
        $('#<%= PrefixName.ClientID %>').on("input", function () {
            CalcLocations();
        });
        function CalcLocations() {
            var pInput = $('#<%= PrefixName.ClientID %>').val();
            var cInput = $('#<%= GridColumns.ClientID %>').val();
            var rInput = $('#<%= GridRows.ClientID %>').val();
            if (rInput > 100 || rInput < 1) {
                $('#AlertMessage').html('You can only generate up to 100 rows. Please enter a number between 1 and 100.');
            } else {

                var charcode = 64 + parseInt(cInput);
                var letter = String.fromCharCode(charcode);
                var locations = cInput * rInput;
                var startRange = pInput + 'A1'; 
                var endRange = pInput + letter + rInput; 
                $('#AlertMessage').html('This will generate ' + locations + ' storage locations with the format: ' + startRange + ' to ' + endRange);
            }
            
        }
    </script>
</asp:Content>
