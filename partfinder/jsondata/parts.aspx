<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        using (DataSet ds = new DataSet())
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                if (Request.QueryString["filter"] != null)
                {
                    int filter = 0;
                    if (Int32.TryParse(Request.QueryString["filter"].ToString(), out filter))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM View_PartsData WHERE PartCategoryID=@PartCategoryID ORDER BY PartName ASC", conn))
                        {
                            da.SelectCommand.Parameters.AddWithValue("@PartCategoryID", filter);
                            da.FillSchema(ds, SchemaType.Source, "View_PartsData");
                            da.Fill(ds, "View_PartsData");
                        }
                    }

                }
                else
                {
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM View_PartsData ORDER BY PartName ASC", conn))
                    {

                        da.FillSchema(ds, SchemaType.Source, "View_PartsData");
                        da.Fill(ds, "View_PartsData");
                    }
                }

                string json = JsonConvert.SerializeObject(ds.Tables[0], Formatting.Indented);
                Response.Write(json);
            }
        }
    }
</script>