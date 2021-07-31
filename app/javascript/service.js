window.addEventListener('load', () => {
  const priceInput = document.getElementById("price-form");
  priceInput.addEventListener("input", () => {
    var inputDate = priceInput.value;
    var inputDate = new Date(inputDate);
    var day2 = new Date("2021/07/25 9:00");
    var shortestDate = (day2 - inputDate) / 86400000;
    document.getElementById("output").innerHTML = shortestDate;
  });
  const leadTime = document.getElementById("lead-time");
  const time = leadTime.textContent;
  document.getElementById("output2").innerHTML = time;
  console.log(time);
});