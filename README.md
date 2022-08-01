- ТЗ:

 
1. Implement displaying of the list of the GitHub users  
   - each item of the list displays user's login and avatar 
   - initial state of list is empty (users can be added only manually) 
2. User can be added to the list only manually by it's login 
   - "+" button in NavigationBar opens a separate screen where you can manually input user's login to add user 
   - login has at least 3 characters 
   - login cannot contain special charachters from this string !@#$%^&* 
3. By selection of the user a separate screen with the list of user's public repositories must be displayed 
   - each item of the list displays repository url 
4. Implement offline mode, displaying latest application state 
5. Write Unit tests 
6. During implementation some colisions and issues will rise. Decide how to solve them by yourself. Also make a log of these issues and desicions you made 


- Write Unit tests - к сожалению не хватило времени
- Комментарии к пункту №6:

1. Если пользователь ничего не добавлял - отображается пустой экран. После добавления и перезапуске отображается список ранее добавленных аккаунтов
2. После добавления логина делается запрос на получение информации по аккаунту ползователя и потом результат отображается на главном экране с подгрузкой аватарки
3. Можно добавлять одинаковые аккаунты - не успел поправить
4. На экране добавления настроена валидация текстового поля с отображением ошибки под полем
5. Вместо лоадеров во время загрузки и алертов при получении ошибок отображаются просто текста. Так сделано для экономии времени. Если нужно можно легко добавить алерты, плашки и тп.
6. На экране деталей ссылки на публичные репозитории отображаются как links. По ним реализованы переходы в Safari. При жесте longTap ссылку можно скопировать в clipboard
