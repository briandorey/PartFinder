<%@ Page Title="Part Finder" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_Load(Object Src, EventArgs E)
    {
        System.Data.DataView dv = (System.Data.DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
        if (dv.Count < 1)
        {
            LitMsg.Text = "You do not have any low stock parts";
        }


        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
        {
            conn.Open();
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT PartPkey  FROM Parts", conn))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    LitPartCount.Text = dt.Rows.Count.ToString();
                }

            }
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT mpkey FROM Manufacturer", conn))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    LitManCount.Text = dt.Rows.Count.ToString();
                }

            }
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT PApkey FROM PartAttachment", conn))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    LitAttachmentCount.Text = dt.Rows.Count.ToString();
                }

            }

            using (SqlDataAdapter da = new SqlDataAdapter("SELECT StorageName FROM StorageLocation", conn))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    LitStorageCount.Text = dt.Rows.Count.ToString();
                }

            }



        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item active" aria-current="page">Overview</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <h2 class=" fw-light">Inventory summary</h2>
    <div class="row mb-3">
        <div class="col-lg-6 col-xl-3 mb-4">
            <div class="card bg-primary text-white h-100 border-0">
                <div class="card-body ">
                    <div class="d-flex justify-content-between align-items-center m-0">
                        <div class="me-3 mb-0">

                            <div class="text-lg h1 fw-light">
                                <asp:Literal ID="LitPartCount" runat="server"></asp:Literal></div>
                            <div class="text-white-75 small">Parts</div>
                        </div>
                        <i class="fa fa-microchip fa-2xl"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between small">
                    <a class="text-white stretched-link" href="/parts/">View List</a>
                    <div class="text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-xl-3 mb-4">
            <div class="card bg-secondary text-white h-100  border-0">
                <div class="card-body ">
                    <div class="d-flex justify-content-between align-items-center m-0">
                        <div class="me-3 mb-0">

                            <div class="text-lg h1 fw-light">
                                <asp:Literal ID="LitManCount" runat="server"></asp:Literal></div>
                            <div class="text-white-75 small">Manufacturers</div>
                        </div>
                        <i class="fa fa-industry fa-2xl"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between small">
                    <a class="text-white stretched-link" href="/manufacturers/">View List</a>
                    <div class="text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-xl-3 mb-4">
            <div class="card bg-success text-white h-100  border-0">
                <div class="card-body ">
                    <div class="d-flex justify-content-between align-items-center m-0">
                        <div class="me-3 mb-0">

                            <div class="text-lg h1 fw-light">
                                <asp:Literal ID="LitAttachmentCount" runat="server"></asp:Literal></div>
                            <div class="text-white-75 small">Part Attachments</div>
                        </div>
                        <i class="fa fa-folder fa-2xl"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between small">
                    <a class="text-white stretched-link" href="/admin/files/">View List</a>
                    <div class="text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-xl-3 mb-4">
            <div class="card bg-info text-white h-100  border-0">
                <div class="card-body ">
                    <div class="d-flex justify-content-between align-items-center m-0">
                        <div class="me-3 mb-0">

                            <div class="text-lg h1 fw-light">
                                <asp:Literal ID="LitStorageCount" runat="server"></asp:Literal></div>
                            <div class="text-white-75 small">Storage Locations</div>
                        </div>
                        <i class="fa fa-box fa-2xl"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between small">
                    <a class="text-white stretched-link" href="/parts/">View List</a>
                    <div class="text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
        </div>
    <div class="row">
                            <div class="col-12">
                                <div class="card mb-4">
                                    <div class="card-header   d-flex flex-row align-items-center justify-content-between">
                                        Low Stock Parts
                                        <a href="/parts/add.aspx" title="Add new"><i class="fas fa-plus me-1"></i></a>
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
        <div class="row mb-3">
            <div class="col-12 ">
                <p class="small">Made with <a href="https://getbootstrap.com/">Bootstrap</a>, <a href="https://github.com/mar10/fancytree">Fancytree</a> and icons from <a href="https://fontawesome.com/">Font Awesome</a>. Developed by <a href="https://www.briandorey.com/">Brian Dorey</a>. Version 1.1.0  June 2022</p>
            </div>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [View_PartsData] WHERE StockLevel <= MinStockLevel ORDER BY StockLevel ASC"></asp:SqlDataSource>
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
