<%@ Page Language="C#" ContentType="text/html"   %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    private void Page_Load(object sender, System.EventArgs e)
    {

        using (System.Data.DataSet dp = new System.Data.DataSet())
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                connection.Open();
                using (SqlDataAdapter daAuthors = new SqlDataAdapter("SELECT PartName ,PartDescription ,PartComment ,StockLevel ,MinStockLevel ,Price ,DateCreated ,DateUpdated ,Condition ,StorageName ,ManufacturerName ,FootprintName ,FootprintImage ,ManufacturerLogo ,PCName ,MPN ,BarCode FROM View_PartsData order by PartName", connection))
                {
                    dp.EnforceConstraints = false;
                    daAuthors.FillSchema(dp, SchemaType.Source, "Parts");
                    daAuthors.Fill(dp, "Parts");
                }
            }


            Response.ClearContent();
            Response.Buffer = true;


            Response.ContentType = "text/csv";



            Response.AppendHeader("Content-Disposition", string.Format("attachment; filename={0}", "parts.csv"));


            StringBuilder sw = new StringBuilder();
            // Write the headers.
            DataTable dt = dp.Tables[0];
            int iColCount = dt.Columns.Count;
            for (int i = 0; i < iColCount; i++)
            {
                sw.Append(dt.Columns[i]);
                if (i < iColCount - 1) sw.Append(",");
            }

            sw.Append(Environment.NewLine);

            // Write rows.
            foreach (DataRow dr in dt.Rows)
            {
                for (int i = 0; i < iColCount; i++)
                {
                    if (!Convert.IsDBNull(dr[i]))
                    {
                        if (dr[i].ToString().StartsWith("0"))
                        {
                            sw.Append(@"=""" + dr[i].ToString().Replace(",", "").Replace(Environment.NewLine,"") + @"""");
                        }
                        else
                        {
                            sw.Append(dr[i].ToString().Replace(",", "").Replace(Environment.NewLine,""));
                        }
                    }

                    if (i < iColCount - 1) sw.Append(",");
                }
                sw.Append(Environment.NewLine);
            }

            Response.Write(sw.ToString());



            Response.End();
        }

    }
</script>