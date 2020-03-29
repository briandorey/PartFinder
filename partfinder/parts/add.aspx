<%@ Page Title="Parts - Add" Language="C#" MasterPageFile="~/MasterPage.master"  %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CategoryHelpers nav = new CategoryHelpers();
            string index = "0";
            if (Helpers.QueryStringIsNotNull("c"))
            {
                index = Helpers.QueryStringReturnNumber("c").ToString();
            }
            nav.LoadCatMenu(PartCategoryID, index);

            PartHelpers fph = new PartHelpers();
            fph.LoadMenu(PartFootprintID, PartManID, StorageLocationID);

            Condition.Items.Add(new ListItem("New", "1"));
            Condition.Items.Add(new ListItem("Used", "0"));
        }
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;


            if (Helpers.TextBoxIsNull(PartName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your part name.</p>";
            }
            if (Helpers.TextBoxIsNull(StockLevel))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter the stock level.</p>";
            }
            if (Helpers.TextBoxIsNull(MinStockLevel))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your minimum stock level.</p>";
            }


            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Parts (PartCategoryID, PartFootprintID,  PartManID, PartName, PartDescription, PartComment, StockLevel, MinStockLevel, Price, DateCreated, DateUpdated, Condition, StorageLocationID, MPN, BarCode) VALUES (@PartCategoryID, @PartFootprintID,  @PartManID, @PartName, @PartDescription, @PartComment, @StockLevel, @MinStockLevel, @Price, @DateCreated, @DateUpdated, @Condition, @StorageLocationID, @MPN, @BarCode)", conn))
                    {
                        cmd.Parameters.AddWithValue("@PartCategoryID", PartCategoryID.SelectedValue);
                        cmd.Parameters.AddWithValue("@PartFootprintID", PartFootprintID.SelectedValue);
                        cmd.Parameters.AddWithValue("@PartManID", PartManID.SelectedValue);
                        cmd.Parameters.AddWithValue("@PartName", PartName.Text);
                        cmd.Parameters.AddWithValue("@PartDescription", PartDescription.Text);
                        cmd.Parameters.AddWithValue("@PartComment", PartComment.Text);
                        cmd.Parameters.AddWithValue("@StockLevel", StockLevel.Text);
                        cmd.Parameters.AddWithValue("@MinStockLevel", MinStockLevel.Text);
                        cmd.Parameters.AddWithValue("@Price", Price.Text);
                        cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
                        cmd.Parameters.AddWithValue("@DateUpdated", DateTime.Now);
                        cmd.Parameters.AddWithValue("@Condition", Condition.SelectedValue);
                        cmd.Parameters.AddWithValue("@StorageLocationID", StorageLocationID.SelectedValue);
                        cmd.Parameters.AddWithValue("@MPN", MPN.Text);
                        cmd.Parameters.AddWithValue("@BarCode", BarCode.Text);

                        cmd.ExecuteNonQuery();
                        cmd.CommandText = "SELECT @@Identity FROM Parts";
                        Decimal iId = (decimal)cmd.ExecuteScalar();

                        Response.Redirect("view.aspx?id=" + iId.ToString());
                    }
                }

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
    <li class="breadcrumb-item"><a href="/parts/">Parts</a></li>
    <li class="breadcrumb-item active" aria-current="page">Add</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Add New Part</h4>
                    <a href="default.aspx" class="btn btn-outline-primary btn-sm"><i class="fas fa-list mr-1"></i>List</a>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>
                    <div class="row">
                        <div class="col-12">
                            <div class="form-group required">
                                <label for="<%= PartName.ClientID %>">Part Name or Reference:</label>
                                <asp:TextBox ID="PartName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>
                                <small id="PartNameHelp" class="form-text text-muted">Enter the Part Name or Reference of your part.</small>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="form-group">
                                <label for="<%= PartDescription.ClientID %>">Description</label>
                                <asp:TextBox ID="PartDescription" CssClass="form-control form-control-sm" runat="server"  MaxLength="250"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="form-group">
                                <label for="<%= PartCategoryID.ClientID %>">Category</label>
                                <asp:DropDownList CssClass="form-control form-control-sm" ID="PartCategoryID" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="form-group required">
                                <label for="<%= PartManID.ClientID %>">Manufacturer</label>
                                <asp:DropDownList CssClass="form-control form-control-sm" ID="PartManID" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="form-group">
                                <label for="<%= Condition.ClientID %>">Condition</label>
                                <asp:DropDownList CssClass="form-control form-control-sm" ID="Condition" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-12 col-md-3 required">
                            <div class="form-group">
                                <label for="<%= StorageLocationID.ClientID %>">Storage Location</label>
                                <asp:DropDownList CssClass="form-control form-control-sm" ID="StorageLocationID" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="form-group">
                                <label for="<%= PartFootprintID.ClientID %>">Footprint</label>
                                <asp:DropDownList CssClass="form-control form-control-sm" ID="PartFootprintID" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="form-group required">
                                <label for="<%= StockLevel.ClientID %>">Stock Level</label>
                                <asp:TextBox ID="StockLevel" CssClass="form-control form-control-sm" runat="server" Text="0" MaxLength="10" required></asp:TextBox>
                                <small id="StockLevelHelp" class="form-text text-muted">Number only.</small>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="form-group required">
                                <label for="<%= MinStockLevel.ClientID %>">Minimum Stock Level</label>
                                <asp:TextBox ID="MinStockLevel" CssClass="form-control form-control-sm" runat="server"  Text="0"  MaxLength="10" required></asp:TextBox>
                                <small id="MinStockLevelHelp" class="form-text text-muted">Number only.</small>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="form-group required">
                                <label for="<%= Price.ClientID %>">Price Each</label>
                                <asp:TextBox ID="Price" CssClass="form-control form-control-sm" runat="server"  Text="0" MaxLength="10" required></asp:TextBox>
                                <small id="PriceHelp" class="form-text text-muted">Number only.</small>
                            </div>
                        </div>
                        
                        <div class="col-12 col-md-6">
                            <div class="form-group">
                                <label for="<%= BarCode.ClientID %>">BarCode</label>
                                <asp:TextBox ID="BarCode" CssClass="form-control form-control-sm" runat="server"  MaxLength="50"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <div class="form-group">
                                <label for="<%= MPN.ClientID %>">MPN</label>
                                <asp:TextBox ID="MPN" CssClass="form-control form-control-sm" runat="server" MaxLength="250"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="form-group">
                                <label for="<%= PartComment.ClientID %>">Notes</label>
                                <asp:TextBox ID="PartComment" CssClass="form-control form-control-sm" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-12">
                            <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save mr-1"></i>Save</button></div>
                    </div>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">
</asp:Content>