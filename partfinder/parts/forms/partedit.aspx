<%@ Page Language="C#" EnableSessionState="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            CategoryHelpers nav = new CategoryHelpers();
            nav.LoadCatMenu(PartCategoryID);

            PartHelpers fph = new PartHelpers();
            fph.LoadMenu(PartFootprintID, PartManID, StorageLocationID);

            Condition.Items.Add(new ListItem("New", "1"));
            Condition.Items.Add(new ListItem("Used", "0"));


            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Parts WHERE PartPkey = @PartPkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@PartPkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                PartCategoryID.SelectedIndex = PartCategoryID.Items.IndexOf(PartCategoryID.Items.FindByValue(dt.Rows[0]["PartCategoryID"].ToString()));
                                PartFootprintID.SelectedIndex = PartFootprintID.Items.IndexOf(PartFootprintID.Items.FindByValue(dt.Rows[0]["PartFootprintID"].ToString()));
                                PartManID.SelectedIndex = PartManID.Items.IndexOf(PartManID.Items.FindByValue(dt.Rows[0]["PartManID"].ToString()));
                                PartName.Text = dt.Rows[0]["PartName"].ToString();
                                PartDescription.Text = dt.Rows[0]["PartDescription"].ToString();
                                PartComment.Text = dt.Rows[0]["PartComment"].ToString();
                                MinStockLevel.Text = dt.Rows[0]["MinStockLevel"].ToString();
                                StockLevel.Text = dt.Rows[0]["StockLevel"].ToString();
                                Price.Text = dt.Rows[0]["Price"].ToString();
                                Condition.SelectedIndex = Condition.Items.IndexOf(Condition.Items.FindByValue(dt.Rows[0]["Condition"].ToString()));
                                StorageLocationID.SelectedIndex = StorageLocationID.Items.IndexOf(StorageLocationID.Items.FindByValue(dt.Rows[0]["StorageLocationID"].ToString()));
                                MPN.Text = dt.Rows[0]["MPN"].ToString();
                                BarCode.Text = dt.Rows[0]["BarCode"].ToString();

                                Session["CurrentStockLevel"] = dt.Rows[0]["StockLevel"].ToString();
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
            if (!Helpers.TextBoxIsInt(StockLevel))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter the stock level as a number.</p>";
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
                    using (SqlCommand cmd = new SqlCommand("UPDATE Parts SET PartCategoryID=@PartCategoryID, PartFootprintID=@PartFootprintID, PartManID=@PartManID, PartName=@PartName, PartDescription=@PartDescription, PartComment=@PartComment, StockLevel=@StockLevel, MinStockLevel=@MinStockLevel ,Price=@Price ,DateUpdated=@DateUpdated ,Condition=@Condition ,StorageLocationID=@StorageLocationID ,MPN=@MPN ,BarCode=@BarCode  WHERE PartPkey=@PartPkey", conn))
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
                        cmd.Parameters.AddWithValue("@DateUpdated", DateTime.Now);
                        cmd.Parameters.AddWithValue("@Condition", Condition.SelectedValue);
                        cmd.Parameters.AddWithValue("@StorageLocationID", StorageLocationID.SelectedValue);
                        cmd.Parameters.AddWithValue("@MPN", MPN.Text);
                        cmd.Parameters.AddWithValue("@BarCode", BarCode.Text);
                        cmd.Parameters.AddWithValue("@PartPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }

                    if (Session["CurrentStockLevel"] != null && Session["CurrentStockLevel"].ToString().Length > 0)
                    {
                        // check old and new stock levels are both numbers.
                        bool res, res2;
                        int IntOldStockLevel;
                        res = int.TryParse(Session["CurrentStockLevel"].ToString(), out IntOldStockLevel);
                        int NewOldStockLevel;
                        res2 = int.TryParse(StockLevel.Text.ToString(), out NewOldStockLevel);

                        if (res  && res2)
                        {
                            if (IntOldStockLevel != NewOldStockLevel)
                            {
                                // stock level has changed, save into history table.

                                using (SqlCommand cmd = new SqlCommand("INSERT INTO PartStockLevelHistory ([PartPkey] ,[StockLevel] ,[DateChanged]) VALUES (@PartPkey ,@StockLevel, @DateChanged)", conn))
                                {
                                    cmd.Parameters.AddWithValue("@PartPkey", Helpers.QueryStringReturnNumber("id"));
                                    cmd.Parameters.AddWithValue("@StockLevel", StockLevel.Text);
                                    cmd.Parameters.AddWithValue("@DateChanged", DateTime.Now);
                                    cmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }
                }

                Helpers.DoLog("Part Updated: " + PartName.Text);
                Response.Redirect("done.aspx?mode=update");
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
                    // get folder path for any attachments
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM View_PartsData WHERE PartPkey = @PartPkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@PartPkey", Helpers.QueryStringReturnNumber("id"));
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                string FolderManName = dt.Rows[0]["ManufacturerName"].ToString().ToLower().Replace(" ","-").CleanString();
                                string FolderPartName = dt.Rows[0]["PartPkey"].ToString().ToLower().Replace(" ","-").CleanString();
                                // check if directory exists

                                bool exists = System.IO.Directory.Exists(Server.MapPath("\\docs\\" + FolderManName + "\\" + FolderPartName));
                                if (exists)
                                {
                                    System.IO.Directory.Delete(Server.MapPath("\\docs\\" + FolderManName + "\\" + FolderPartName), true);
                                }
                            }
                        }
                    }
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Parts WHERE PartPkey=@PartPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@PartPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartAttachment WHERE PartID=@PartID", conn))
                    {
                        cmd.Parameters.AddWithValue("@PartID", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartParameter WHERE PartID=@PartID", conn))
                    {
                        cmd.Parameters.AddWithValue("@PartID", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartSuppliers WHERE PartID=@PartID", conn))
                    {
                        cmd.Parameters.AddWithValue("@PartID", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartStockLevelHistory WHERE PartPkey=@PartPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@PartPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("done.aspx?mode=deletepart");
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
                        <div class="col-12 required">
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
                        <div class="col-12 text-center">
                    <button runat="server" id="ButtonUpdate" class="btn btn-primary px-4 btn-lg ">Save</button>
                    </div>
                   
                    </div>
                   
            <div class="row">
    <div class="col-12 pt-4">
    <div class="alert alert-danger text-center py-3" role="alert">
                  <h4>Delete Part</h4>
                    <p>Are you sure you want to delete this item and all related files?</p>
                     <a href="partedit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true"  ID="ButtonDelete" class="btn btn-danger  btn-sm">Delete Part and Attachments</a>
                    <asp:Literal ID="LitDeleteMsg" runat="server"></asp:Literal>
                    </div>
        </div>
          </div>
                </div>
    </form>
</body>
</html>
