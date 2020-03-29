using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for FootprintHelpers
/// </summary>
public class PartHelpers
{

    public PartHelpers()
    {
    }
    public void LoadMenu(DropDownList FootPrintMenu, DropDownList ManufacturerMenu, DropDownList StorageLocationMenu)
    {
        using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
        {
            connection.Open();

            // populate footprints dropdown menu
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT FCName, FootprintName, FootprintPkey FROM View_FootprintsCats ORDER BY FCName ASC, FootprintName ASC", connection))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    foreach (System.Data.DataRowView drv in dt.DefaultView)
                    {
                        FootPrintMenu.Items.Add(new ListItem(drv["FCName"].ToString() + " > " + drv["FootprintName"].ToString(), drv["FootprintPkey"].ToString()));
                    }
                }
            }
            // populate Manufacturer dropdown menu
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT mpkey, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName ASC", connection))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    foreach (System.Data.DataRowView drv in dt.DefaultView)
                    {
                        ManufacturerMenu.Items.Add(new ListItem(drv["ManufacturerName"].ToString(), drv["mpkey"].ToString()));
                    }
                }
            }
            // populate storage locations menu
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT StoragePkey, StorageName FROM StorageLocation ORDER BY StorageSortOrder ASC", connection))
            {
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    foreach (System.Data.DataRowView drv in dt.DefaultView)
                    {
                        StorageLocationMenu.Items.Add(new ListItem(drv["StorageName"].ToString(), drv["StoragePkey"].ToString()));
                    }
                }
            }
            




        }
    }
}