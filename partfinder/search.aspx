<%@ Page Title="Part Finder - Search" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_Load(Object Src, EventArgs E)
    {
        System.Data.DataView dv = (System.Data.DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
        if (dv.Count < 1)
        {
            LitMsg.Text = "Your search did not match any parts";
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item active" aria-current="page">Search Results</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 ">
            <div class="card mb-4">
                <div class="card-header  d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Your Search Results</h4>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitMsg" runat="server"></asp:Literal>
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
                                        <th>
                                            <asp:LinkButton runat="server" ID="LinkButton7" CommandName="Sort"
                                                CommandArgument="Barcode">Barcode</asp:LinkButton></th>

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
                                        <td><%#Eval("BarCode") %></td>

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
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [View_PartsData] WHERE PartName LIKE '%' + @PartName + '%' OR PartDescription LIKE '%' + @PartDescription + '%' OR BarCode LIKE '%' + @BarCode + '%' ">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="None" Name="PartName" QueryStringField="searchbox" Type="String" />
            <asp:QueryStringParameter DefaultValue="None" Name="PartDescription" QueryStringField="searchbox" Type="String" />
            <asp:QueryStringParameter DefaultValue="None" Name="BarCode" QueryStringField="searchbox" Type="String" />
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
