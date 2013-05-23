<%@page import="ge.iauto.data.Location"%>
<%@page import="java.util.Iterator"%>
<%@page import="ge.iauto.data.Category"%>
<%@page import="java.util.List"%>
<%@page import="ge.iauto.data.CarModel"%>
<%@page import="ge.iauto.data.CarMake"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>www.IAuto.ge - დამატება</title>

<%@include file="menu-bar.jsp"%>

<style>
#adding {
	background: #66CCFF;
	padding: 3px 17px;
	color: black;
	font-family: 'Helvetica Neue', sans-serif;
	font-size: 15px;
	border-radius: 2px;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	border: 0px solid rgb(213, 150, 17);
	cursor: pointer;
}

#adding.cover {
	background-color: #3399FF;
	color: black;
}
</style>
<script type="text/javascript">
	function BoxChange(selectObj) {
		var idx = selectObj.selectedIndex;
		var which = selectObj.options[idx].value;
		if(which == ""){
			var cSelect = document.getElementById("model");
			while (cSelect.options.length > 0) {
				cSelect.remove(0);
			}
			var newOption;
			newOption = document.createElement("option");
			newOption.value = "";
			newOption.text = "ყველა";
			try {
				cSelect.add(newOption); 
			} catch (e) {
				cSelect.appendChild(newOption);
			}	
			return;
		}
		var cSelect = document.getElementById("model");
		while (cSelect.options.length > 0) {
			cSelect.remove(0);
		}
		var newOption;
		var cList = [];
		<%
		@SuppressWarnings("unchecked")
		HashMap<String,Long> car = (HashMap<String,Long>)request.getServletContext().getAttribute("idByName");
		@SuppressWarnings("unchecked")
		HashMap<Long,CarMake> models = (HashMap<Long,CarMake>)request.getServletContext().getAttribute("carById");
		for(String name : car.keySet()){	
		%>
			if(which == "<%=name%>"){
			<%
				for(CarModel model : models.get(car.get(name)).getModels()){
			%>
					cList.push("<%=model.getName()%>");
			<%
				}
			%>		
			}
		<%
		}
		%>
		for ( var i = 0; i < cList.length; i++) {
			newOption = document.createElement("option");
			newOption.value = cList[i];
			newOption.text = cList[i];
			try {
				cSelect.add(newOption); 
			} catch (e) {
				cSelect.appendChild(newOption);
			}
		}
	}
</script>



<body>
	<form action="AddingCars" method="post">
		<table width=800 cellspacing=3 border=0>
			<tr>
				<td align=right><strong>კატეგორია:</strong></td>
				<td align=left><select name=category_id
					style="border: dashed #660 1px;" onchange="change_run();"
					id=category_id>
						<option value="">აირჩიეთ კატეგორია</option>
						<%
							@SuppressWarnings("unchecked")
							List<Category> categeory = (List<Category>) request
									.getServletContext().getAttribute("categories");
							Iterator<Category> it = categeory.iterator();
							while (it.hasNext()) {
								Category tmp = it.next();
						%>
						<option value=<%=tmp.getId()%>><%=tmp.getName()%></option>
						<%
							}
						%>
				</select> 
				<img src="http://www.myauto.ge/images/attention_icon.gif"
					width="30" height="30" style="margin-top: -4px;" /></td>
			</tr>
			<tr>
				<td align=right>მწარმოებელი:</td>
				<td align=left>
				<select name="man_id" id="man_id" 	onChange="BoxChange(this);" tabindex="1">
						<option value="" selected="selected">მწარმოებელი</option>
							<option value="">ყველა</option>
							<%
							@SuppressWarnings("unchecked")
							HashMap<String,Long> cars = (HashMap<String,Long>)request.getServletContext().getAttribute("idByName");
							for(String ids : cars.keySet()){
							%>
								<option value="<%=ids%>" id="<%=cars.get(ids)%>"><%=ids%></option>
							<%}%>
				</select></td>
				<td align="right">ფასი:</td>
				<td align="left"><input name="price" id="price" size="6"
					maxlength="8" onkeypress="return keyfilter_num(event)" /> <select
					name="currency_id" id="currency_id">
						<option value="0">$</option>
						<option value="1">ევრო</option>
						<option value="2">ლარი</option>
				</select><br /> <input type="checkbox" name="customs_passed" /> განბაჟებული</td>
			</tr>
			<tr>
				<td align="right">მოდელი:</td>
				<td align="left"><select name="model" id="model" class="seleqtebi">
							<option value="" selected="selected">მოდელი</option>
					</select> <input name="model" size="10" maxlength="10" /></td>
				<td align="right">გაცვლა:</td>
				<td align="left"><input type="checkbox" name="changable" /></td>
			</tr>

			<tr>
			<tr>
				<td align="right">მდებარეობა:</td>
				<td align="left"><select name="location_id" id="location_id">
						<%
							@SuppressWarnings("unchecked")
							List<Location> locat = (List<Location>) request.getServletContext()
									.getAttribute("locations");
							Iterator<Location> it1 = locat.iterator();
							while (it1.hasNext()) {
								Location tmp = it1.next();
						%>
						<option value=<%=tmp.getId()%>><%=tmp.getName()%></option>
						<%
							}
						%>
				</select></td>
				<td align=right>ამჟამად იყიდება აუქციონზე:</td>
				<td align=left><input type="checkbox" name="is_auction"
					id="is_auction" onClick="auctionOnClick()"></td>
			</tr>

			<tr>
				<td align=right>გამოშვების წელი:</td>
				<td align=left><select name='prod_year' id='prod_year'>
						<option></option>
						<%
							for (int k = 1960; k <= 2013; k++) {
						%>
						<option value=<%=k%>><%=k%></option>
						<%
							}
						%>
				</select> თვე: <select name="prod_month"><option value=""></option>
						<%
							for (int k = 1; k <= 12; k++) {
						%>
						<option value=<%=k%>><%=k%></option>
						<%
							}
						%>
				</select></td>
				<td align=right>ძრავის მოცულობა:</td>
				<td align=left><select name=engine_volume>
						<option selected="selected" value=''></option>
						<%
							for (int k = 1; k <= 80; k++) {
								double motor = k / (double) 10;
								int value = k * 100;
						%>
						<option value=<%=value%>><%=motor%></option>
						<%
							}
						%>

				</select></td>
			</tr>
			<tr>
				<td align=right>გარბენი</td>
				<td align=left><input name="car_run" size="7" maxlength="7"
					onKeyPress="return keyfilter_num(event)"> <select
					name="car_run_dim" id="car_run_dim"><option value="1">კმ.</option>
						<option value="2">მილი</option>
				</select></td>
				<td align=right>ცილინდრები:</td>
				<td align=left><select name=cylinders>
						<%
							for (int k = 1; k <= 12; k++) {
						%>
						<option value=<%=k%>><%=k%></option>
						<%
							}
						%>
				</select></td>
			</tr>
			<tr>
				<td align=right>კარები:</td>
				<td align=left><select name=door_type_id>
						<option value=2>4/5</option>
						<option value=1>2/3</option>
						<option value=3>1</option>
						<option value=4>5</option>
						<option value=5>0</option>
				</select></td>
				<td align=right>წამყვანი თვლები:</td>
				<td align=left><select name=drive_type_id>
						<option value=1>წინა</option>
						<option value=2>უკანა</option>
						<option value=3>4x4</option>
				</select></td>

			</tr>
			<tr>
				<td align=right>აირბეგი:</td>
				<td align=left><select name=airbags>
						<%
							for (int k = 1; k <= 12; k++) {
						%>
						<option value=<%=k%>><%=k%></option>
						<%
							}
						%>
				</select></td>
				<td align=right>საწვავის ტიპი:</td>
				<td align=left><select name=fuel_type_id>
						<option value=2>ბენზინი</option>
						<option value=1>ბენზინი/კარბურატორი</option>
						<option value=3>დიზელი</option>
						<option value=4>ტურბოდიზელი</option>
						<option value=5>გაზი/ბენზინი</option>
						<option value=6>ჰიბრიდი</option>
						<option value=7>ელექტრო</option>
				</select></td>
			</tr>

			<tr>
				<td align=right>ქირავდება:</td>
				<td align=left><input type="checkbox" name="forrent"></td>
				<td align=right>ფერი:</td>
				<td align=left><select name=color_id>
						<option value=16>შავი</option>
						<option value=1>თეთრი</option>
						<option value=2>ბეჟი</option>
						<option value=3>ცისფერი</option>
						<option value=4>ყვითელი</option>
						<option value=5>მწვანე</option>
						<option value=6>ოქროსფერი</option>
						<option value=7>ყავისფერი</option>
						<option value=8>წითელი</option>
						<option value=9>სტაფილოსფერი</option>
						<option value=11>შინდისფერი</option>
						<option value=12>ვერცხლისფერი</option>
						<option value=13>ნაცრისფერი</option>
						<option value=14>ლურჯი</option>
						<option value=17>ბადრიჯნისფერი</option>
				</select></td>
			</tr>
			<tr>
				<td align=right>გადაცემათა კოლოფი:</td>
				<td align=left><select name="gear_type_id">
						<option value=1>მექანიკა</option>
						<option value=2>ავტომატიკა</option>
						<option value=3>ტიპტრონიკი</option>
				</select></td>

				<td align=right>მარჯვენა საჭე:</td>
				<td align="left"><input type="checkbox" name="right_wheel" /></td>
			</tr>
			<tr>
				<td align=right></td>
				<td align=left></td>
				<td align=right>ტურბო:</td>
				<td align="left"><input type="checkbox" name="has_turbo">
				</td>
			</tr>
			<tr>
				<td align="right">თქვენი სახელი:</td>
				<td align="left"><input name="client_nm" size="10"
					maxlength="30"></td>
				<td align="right">თქვენი ტელეფონი:</td>
				<td align="left" width="220px"><label id="lab_client_phone">
				</label> <input name="client_phone_1" id="client_phone_1" value="" size="6"
					maxlength="9" onKeyPress="return keyfilter_num(event)"> <!-- <br/><input type="checkbox" checked="checked" id="is_georgia" onclick="georgiaOnClick()" name="is_georgia" />საქართველო -->
				</td>
			</tr>

			<tr>
				<td align=right>ABS:</td>
				<td align=left><input type=checkbox name=abs></td>
				<td align=right>პარკინგკონტროლი:</td>
				<td align=left><input type=checkbox name=obstacle_indicator>
				</td>

			</tr>
			<tr>
				<td align=right>ელ. შუშები:</td>
				<td align=left><input type=checkbox name=el_windows></td>
				<td align=right>კონდინციონერი:</td>
				<td align=left><input type=checkbox name=condintioner></td>
			</tr>
			<tr>
				<td align=right>კლიმატკონტროლი:</td>
				<td align=left><input type=checkbox name=climat_control>
				</td>
				<td align=right>ტყავის სალონი:</td>
				<td align=left><input type=checkbox name=leather></td>
			</tr>
			<tr>
				<td align=right>დისკები:</td>
				<td align=left><input type=checkbox name=disks></td>
				<td align=right>ნავიგაცია:</td>
				<td align=left><input type=checkbox name=nav_system></td>
			</tr>
			<tr>
				<td align=right>ლუქი:</td>
				<td align=left><input type=checkbox name=hatch></td>
				<td align=right>ცენტრალური საკეტი:</td>
				<td align=left><input type=checkbox name=central_lock></td>
			</tr>
			<tr>
				<td align=right>ბორტკომპიუტერი:</td>
				<td align=left><input type=checkbox name=board_comp></td>
				<td align=right>სავარძლების გათბობა:</td>
				<td align=left><input type=checkbox name=chair_warming></td>
			</tr>
			<tr>
				<td align=right>სიგნალიზაცია:</td>
				<td align=left><input type=checkbox name=alarm></td>
				<td align=right>ჰიდრავლიკა:</td>
				<td align=left><input type=checkbox name=hydraulics></td>
			</tr>
			<tr valign=top>

				<td align=right></td>
				<td align=left><input type="text" size=7 MAXLENGTH=4
					onKeyPress="return keyfilter_num(event)" name="import_year" /> <select
					name="import_month"><option value=""></option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						<option value="6">6</option>
						<option value="7">7</option>
						<option value="8">8</option>
						<option value="9">9</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option></select> <br />(თუ გზაშია, მაშინ ჩამოსვლის
					თარიღი)</td>
			</tr>
		</table>

		<div align="center">
			მოკლე აღწერა<br> <br>
			<textarea cols="60" rows="5" name="discription">
				 </textarea>
			<br> <br>
		</div>

		<table cellspacing=10 border=0>
			<tr>
				<td align=right width=250>I სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo1" size=80>
				</td>
			</tr>
			<tr>
				<td align=right width=250>II სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo2" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>III სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo3" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>IV სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo4" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>V სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo5" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>VI სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo6" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>VII სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo7" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>VIII სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo8" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>IX სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo9" size=80>
				</td>
			</tr>

			<tr>
				<td align=right width=250>X სურათი (640x480) :</td>
				<td align=left><input type="FILE" name="photo10" size=80>
				</td>
			</tr>

			<tr>
				<td align="center"><br> <input id="adding" type="submit"
					value="დამატება" /></td>
			</tr>

		</table>
	</form>
</body>
</html>

