<%@ Page Title="Part Finder Admin" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
  <li class="breadcrumb-item active" aria-current="page">Admin</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
  
     <div class="row">
         <!-- Start Users -->
    <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-primary  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-uppercase mb-4">User Management</div>
                      <div class="mb-4"><a href="/admin/users/default.aspx" class="text-gray-800"> <i class="fa fa-fw fa-users me-3"></i>List Users</a></div>
                        <div class=" mb-0"><a href="/admin/users/add.aspx" class="text-gray-800"> <i class="fa fa-fw fa-user-plus me-3"></i>Add User</a></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-user fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Users -->
         <!-- Start Category -->
         <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-success  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-uppercase mb-4">Category Management</div>
                      <div class=" mb-4"><a href="/admin/category/treeview.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder me-3"></i>List Categories</a></div>
                        <div class=" mb-0"><a href="/admin/category/add.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder-plus me-3"></i>Add Category</a></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-folder fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Category -->

         <!-- Start Footprint Category -->
         <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-secondary  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class=" text-uppercase mb-4">Footprint Category Management</div>
                      <div class=" mb-4"><a href="/admin/footprintcategory/default.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder me-3"></i>List Footprint Categories</a></div>
                        <div class=" mb-0"><a href="/admin/footprintcategory/add.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder-plus me-3"></i>Add Footprint Category</a></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-shoe-prints fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Footprint Category -->

         <!-- Start Footprints -->
         <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-warning  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-uppercase mb-4">Footprint Management</div>
                      <div class=" mb-4"><a href="/admin/footprints/default.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder me-3"></i>List Footprints</a></div>
                        <div class=" mb-0"><a href="/admin/footprints/add.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder-plus me-3"></i>Add Footprint</a></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-shoe-prints fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Footprints -->
         <!-- Start Storage Locations -->
         <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-info  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-uppercase mb-4">Storage Locations Management</div>
                      <div class=" mb-4"><a href="/admin/storagelocations/default.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder me-3"></i>List Storage Locations</a></div>
                        <div class=" mb-0"><a href="/admin/storagelocations/add.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder-plus me-3"></i>Add Storage Location</a></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-box fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Storage Locations -->
          <!-- Start Manufacturers Locations -->
         <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-primary  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-uppercase mb-4">Manufacturers Management</div>
                      <div class=" mb-4"><a href="/admin/manufacturers/default.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder me-3"></i>List Manufacturers</a></div>
                        <div class=" mb-0"><a href="/admin/manufacturers/add.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder-plus me-3"></i>Add Manufacturer</a></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-industry fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Manufacturers Locations -->
           <!-- Start File Manager Locations -->
         <div class="col-xl-6 col-md-6 mb-4">
              <div class="card border-left-danger  h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-uppercase mb-4">File Manager</div>
                      <div class=" mb-4"><a href="/admin/files/default.aspx" class="text-gray-800"> <i class="fa fa-fw fa-folder me-3"></i>Manage Files and Folders</a></div>
                     
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-folder fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
         <!-- End Manufacturers Locations -->

        </div>

  
   
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" Runat="Server">
</asp:Content>