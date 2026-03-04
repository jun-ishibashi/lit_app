// 検索結果ページで日付・リードタイム計算用（該当要素がある場合のみ実行）
window.addEventListener('load', () => {
  const priceInput = document.getElementById('price-form');
  const output = document.getElementById('output');
  const leadTime = document.getElementById('lead-time');
  const output2 = document.getElementById('output2');

  if (priceInput && output) {
    priceInput.addEventListener('input', () => {
      const inputDate = new Date(priceInput.value);
      const day2 = new Date('2021/07/25 9:00');
      const shortestDate = (day2 - inputDate) / 86400000;
      output.innerHTML = shortestDate;
    });
  }

  if (leadTime && output2) {
    output2.innerHTML = leadTime.textContent;
  }
});
