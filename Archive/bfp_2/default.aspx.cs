using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Security;
using System.Security.Principal;
using System.Text;
using BWA.BFP.Data;
using BWA.BFP.Core;

namespace BWA.BFP.Web
{
	public class _default : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Label lbErr;
		protected System.Web.UI.WebControls.RequiredFieldValidator LoginEmailValidator;
		protected System.Web.UI.WebControls.RegularExpressionValidator LoginEmailRegExp;
		protected System.Web.UI.WebControls.TextBox tbPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator PasswordValidator;
		protected System.Web.UI.WebControls.RegularExpressionValidator PasswordRegExp;
		protected System.Web.UI.WebControls.Button btLogin;
		protected System.Web.UI.WebControls.DropDownList ddlOrg;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvOrgs;
		protected System.Web.UI.WebControls.TextBox tbEmail;
		protected System.Web.UI.HtmlControls.HtmlTable tblLogin;

		private clsUsers user = null;
		
		private void Page_Load(object sender, System.EventArgs e)
		{
			try
			{
				HttpContext.Current.Cache.Remove("userPages");
				if(Request.QueryString.ToString() == "logoff")
				{
					Response.Cookies["bfp_roles"].Value = null;
					Response.Cookies["bfp_roles"].Expires = DateTime.Now.AddHours(-1);
					Response.Cookies["bfp_roles"].Path = "/";

					FormsAuthentication.SignOut();

					Session.RemoveAll();
				}
				if(!IsPostBack)
				{
					tblLogin.Rows[1].Visible = false;
				}
			}
			catch(Exception ex)
			{
				_functions.Log("Application error: \n" + ex.ToString());
			}
			finally
			{
				if(user != null)
				{
					user.Dispose();
				}
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.btLogin.Click += new System.EventHandler(this.btLogin_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void btLogin_Click(object sender, System.EventArgs e)
		{
			string sUserData;
			string[] roles;
			DataTable dtGroups = null;
			int iReturn;
			try
			{
				user = new clsUsers();
				user.sEmail = tbEmail.Text;
				user.sPass = tbPassword.Text;
				if(tblLogin.Rows[1].Visible)
					user.iOrgId = Convert.ToInt32(ddlOrg.SelectedValue);
				iReturn = user.Authenticate();
				switch(iReturn)
				{
					case 0:
						lbErr.Visible = false;
						sUserData = user.iId.Value.ToString() + ":" + user.iOrgId.Value.ToString();

						dtGroups = user.GetUserGroupsList();

						string roleStr = "";
						foreach (DataRow dr in dtGroups.Rows) 
						{
							roleStr += String.Format("{0};", dr["vchDesc"]);
						}
						roleStr = roleStr.Remove(roleStr.Length - 1, 1);

						FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
							1,
							sUserData,
							DateTime.Now,
							DateTime.Now.AddHours(1),
							false,
							roleStr
							);

						roles = roleStr.Split(new char[] {';'});

						string cookieStr = FormsAuthentication.Encrypt(ticket);

						Response.Cookies["bfp_roles"].Value = cookieStr;
						Response.Cookies["bfp_roles"].Path = "/";
						Response.Cookies["bfp_roles"].Expires = DateTime.Now.AddHours(1);

						FormsAuthentication.SetAuthCookie(sUserData, true);
						Response.Redirect("main.aspx", false);
						break;
					case 1:
						tblLogin.Rows[1].Visible = true;
						ddlOrg.DataTextField = "vchName";
						ddlOrg.DataValueField = "Id";
						ddlOrg.DataSource = new DataView(user.GetOrgListFromUser());
						ddlOrg.DataBind();
						lbErr.Visible = false;
						break;
					case -1:
						lbErr.Visible = true;
						break;
					default:
						lbErr.Visible = true;
						break;
				}

			}
			catch(Exception ex)
			{
				_functions.Log("Application error: \n" + ex.ToString());
				lbErr.Text = ex.Message;
			}
			finally
			{
				if(user != null)
				{
					user.Dispose();
				}
			}
		}
	}
}
