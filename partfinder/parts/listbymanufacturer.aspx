<%@ Page Title="Part Finder" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">

    protected void Page_Load(Object Src, EventArgs E)
    {
        System.Data.DataView dv = (System.Data.DataView)SqlDataSourceFootprint.Select(DataSourceSelectArguments.Empty);
        if (dv.Count > 0)
        {
            foreach (System.Data.DataRowView drvSql in dv)
            {

                LitName.Text = drvSql["ManufacturerName"].ToString();
                ManufacturerAddress.Text = drvSql["ManufacturerAddress"].ToString();
                ManufacturerURL.Text = "<a href=\"" + drvSql["ManufacturerURL"].ToString() + "\" target=\"_blank\">" + drvSql["ManufacturerURL"].ToString() + "</a>";
                ManufacturerPhone.Text = drvSql["ManufacturerPhone"].ToString();
                ManufacturerEmail.Text = "<a href=\"mailto:" + drvSql["ManufacturerEmail"].ToString() + "\">" + drvSql["ManufacturerEmail"].ToString() + "</a>";
                if (drvSql["ManufacturerLogo"].ToString().Trim().Length > 1)
                {
                    ManufacturerLogo.Text = "<img src=\"" + drvSql["ManufacturerLogo"].ToString() + "\" >";
                }
                ManufacturerComment.Text = drvSql["ManufacturerComment"].ToString();
            }
        }
    }


</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item active" aria-current="page">Parts by Manufacturer</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h1 class="font-weight-light h3">
                        <asp:Literal ID="LitName" runat="server"></asp:Literal></h1>
                </div>
                <div class="card-body">
                    <div class="row border-bottom pb-2 mb-3">
                        <div class="col-12 col-md-5">
                            <p>
                                Address: 
                                <asp:Literal ID="ManufacturerAddress" runat="server"></asp:Literal>
                            </p>
                            <p>
                                Web: 
                                <asp:Literal ID="ManufacturerURL" runat="server"></asp:Literal>
                            </p>
                            <p>
                                Phone: 
                                <asp:Literal ID="ManufacturerPhone" runat="server"></asp:Literal>
                            </p>
                            <p>
                                Email: 
                                <asp:Literal ID="ManufacturerEmail" runat="server"></asp:Literal>
                            </p>


                        </div>
                        <div class="col-12 col-md-5">
                            <p>
                                Notes:<br />
                                <asp:Literal ID="ManufacturerComment" runat="server"></asp:Literal>
                            </p>

                        </div>
                        <div class="col-12 col-md-5">
                            <asp:Literal ID="ManufacturerLogo" runat="server"></asp:Literal></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card shadow mb-4">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Parts: 
                    </h4>
                    <div>
                        <a href="default.aspx" class="mr-3" title="Tree View"><i class="fas fa-stream mr-1"></i></a>
                        <a href="add.aspx" title="Add new"><i class="fas fa-plus mr-1"></i></a>
                    </div>
                </div>
                <div class="card-body p-0 pb-3">
                    <!-- start content -->
                    <div class="table-responsive">
                        <table class="table border-bottom tablelinks">
                            <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1">
                                <LayoutTemplate>
                                    <tr>
                                        <th>
                                            <asp:LinkButton runat="server" ID="SortByName" CommandName="Sort"
                                                CommandArgument="PartName">Name</asp:LinkButton></th>
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton1" CommandName="Sort"
                                                CommandArgument="PartDescription">Description</asp:LinkButton></th>
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton2" CommandName="Sort"
                                                CommandArgument="StockLevel">Stock</asp:LinkButton></th>
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton3" CommandName="Sort"
                                                CommandArgument="StorageName">Location</asp:LinkButton></th>
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton4" CommandName="Sort"
                                                CommandArgument="ManufacturerName">Manufacturer</asp:LinkButton></th>
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton5" CommandName="Sort"
                                                CommandArgument="FootprintName">Footprint</asp:LinkButton></th>
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton6" CommandName="Sort"
                                                CommandArgument="PCName">Category</asp:LinkButton></th>

                                    </tr>
                                    <asp:PlaceHolder runat="server" ID="itemPlaceholder"></asp:PlaceHolder>
                                </LayoutTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><a href="/parts/view.aspx?id=<%#Eval("PartPkey") %>"><%#Eval("PartName") %></a></td>
                                        <td><%#Eval("PartDescription") %></td>
                                        <td><%#Eval("StockLevel") %></td>
                                        <td><%#Eval("StorageName") %></td>
                                        <td><%#Eval("ManufacturerName") %></td>
                                        <td><%#Eval("FootprintName") %></td>
                                        <td><%#Eval("PCName") %></td>

                                    </tr>
                                </ItemTemplate>
                            </asp:ListView>
                        </table>
                    </div>
                    <div class="row">
                        <div class="col-12 text-center">
                            <asp:DataPager ID="it" runat="server" PagedControlID="ListView1" PageSize="20" class="btn-group btn-group-sm">
                                <Fields>
                                    <asp:NumericPagerField ButtonType="Link" CurrentPageLabelCssClass="btn btn-primary rounded-0" RenderNonBreakingSpacesBetweenControls="false"
                                        NumericButtonCssClass="btn btn-outline-primary rounded-0" ButtonCount="10" NextPageText="..." NextPreviousButtonCssClass="btn btn-default rounded-0" />
                                </Fields>
                            </asp:DataPager>
                        </div>
                    </div>
                    <!-- end content -->
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [View_PartsData] WHERE (PartManID = @PartManID) ORDER BY [PartName]">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="PartManID" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceFootprint" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [Manufacturer] WHERE ([mpkey] = @mpkey)">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="mpkey" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">

    <script>
        $(document).ready(function () {

            $('.table tr').click(function () {
                var href = $(this).find("a").attr("href");
                if (href) {
                    window.location = href;
                }
            });

        });
    </script>
</asp:Content>
