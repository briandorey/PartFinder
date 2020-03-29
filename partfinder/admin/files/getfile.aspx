<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
    <script runat="server">

        void Page_Load(object sender, EventArgs e) {
            if (Helpers.QueryStringIsNotNull("f"))
            {
                try
                {

                    string filename = Request.QueryString["f"].ToString();

                    FileInfo FI = new FileInfo(@Server.MapPath(filename));
                    string strFilename = FI.Name;
                    Response.AddHeader("content-disposition", "attachment; filename=" + strFilename);

                    FileStream sourceFile = new FileStream(@Server.MapPath(filename), FileMode.Open);
                    long FileSize;
                    FileSize = sourceFile.Length;
                    byte[] getContent = new byte[(int)FileSize];
                    sourceFile.Read(getContent, 0, (int)sourceFile.Length);
                    sourceFile.Close();

                    Response.BinaryWrite(getContent);
                } catch 
                {
                    Response.Write("File not found");
                }
            }
        }
    </script>