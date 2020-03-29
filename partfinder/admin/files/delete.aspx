<%@ Page Language="C#" ContentType="text/html" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
  
    
protected void Page_Load(Object Src, EventArgs E)
{
  	
	try {

        if (Helpers.QueryStringIsNotNull("f"))
        {
				if (Request.QueryString["mode"].ToString().Equals("file")) {
					// file delete
					string DirToDelete = Request.QueryString["f"];
					FileInfo FI = new FileInfo(@Server.MapPath("\\docs\\" + DirToDelete)); 
					string strFilename = FI.Name;
					
					File.Delete(@Server.MapPath("\\docs\\" + Request.QueryString["f"]));
                    
                    
                    
					Response.Redirect("default.aspx?d=" + Request.QueryString["f"].Replace(strFilename,"").Replace("/","%5C"));
					} else  {
					// folder delete
					string DirToDelete = Request.QueryString["f"];
						if (DirToDelete.Equals("/")) {
							Response.Write("You cannot delete the main docs folder, please press back on your web browser to return to the previous page");
						} else {
							DirectoryInfo FI = new DirectoryInfo(@Server.MapPath("\\docs\\" + DirToDelete)); 
							string parentdir = FI.Name;
							
							Directory.Delete(@Server.MapPath("\\docs\\" + Request.QueryString["f"]),true);
                            
							Response.Redirect("default.aspx?d=" + Request.QueryString["f"].Replace(parentdir,"").Replace("/","%5C"));
						}
					}
					
			}			
		} 
		catch ( Exception e )
		{
		Response.Write(e.Message.ToString());
		}
}
</script>