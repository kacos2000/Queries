  ## SQLite queries ##
  -   
      - **Browsers**
        -  Mozilla Firefox *61+*:
            - [firefox_places.sql](https://github.com/kacos2000/queries/blob/master/firefox_places.sql) 
            - [firefox_favicons.sql](https://github.com/kacos2000/queries/blob/master/firefox_favicons.sql) 
            - [firefox_formhistory.sql](https://github.com/kacos2000/queries/blob/master/firefox_formhistory.sql) 
            - [firefox_contentprefs.sql](https://github.com/kacos2000/queries/blob/master/firefox_contentprefs.sql) 
      
        - Opera *54+*
          - [Opera_History.sql](https://github.com/kacos2000/queries/blob/master/Opera_History.sql)
          - [Chrome_favicons.sql](https://github.com/kacos2000/queries/blob/master/chrome_favicons.sql) *(works with Opera as well)*
      
        - Chrome *67+*
          - [Opera_History.sql](https://github.com/kacos2000/queries/blob/master/Opera_History.sql) *(works with Chrome as well)*
          - [Chrome_favicons.sql](https://github.com/kacos2000/queries/blob/master/chrome_favicons.sql)

      
       - **Skype**  *(version 7.21 & 7.41 dBs)*    
       
           - [skype_main.sql](https://github.com/kacos2000/queries/blob/master/skype_main_db.sql)<br>
             Query Skype's *(Classic)* main.db for chats & file transfers.<br>
             
           - [skype_cache_db](https://github.com/kacos2000/queries/blob/master/skype_cache_db.sql)<br>
             Query Skype's *(Classic)* both cache_db.db databases found at AppData\Roaming\UserProfile\media_messaging\ <br>
             - 'emo_cache_v2\asyncdb\cache_db'   *(cached Emoticons etc)* & <br> 
             - 'media_cache_v3\asyncdb\cache_db' *(Cached Sent & Received images)* folders.<br>
                     
           - [PowerShell script/sqlite query](https://github.com/kacos2000/queries/blob/master/cache_db.ps1) so that you can view the Hex Blob output<br>
             - [Sample Output (csv)](https://github.com/kacos2000/queries/blob/master/cache_db.csv)<br><br>


       - **Google Drive**   <br>     
           - Query Google Drive's [snapshot.db](https://github.com/kacos2000/queries/blob/master/GDrive_snapshot.sql) found at the '\AppData\Local\Google\Drive\user@' folder  .<br>
            - Query Google Drive's [cloud_graph.db](https://github.com/kacos2000/queries/blob/master/GDrive_cloudgraph.sql) found at the '\AppData\Local\Google\Drive\user@\cloud_graph' folder <br><br>
             
       - **Android**   <br>     
            - [Android 7 Calllog.db (Call history)](https://github.com/kacos2000/queries/blob/master/calllog_db.sql)<br>
            - [Android 7 Contacts2.db (Contacts)](https://github.com/kacos2000/queries/blob/master/contacts2.sql)<br>
            - [Android 9 Contacts2.db (Call history)](https://github.com/kacos2000/queries/blob/master/contacts2calls.sql)<br>
            - [Android logs.db (Samsung Calls/messages)](https://github.com/kacos2000/queries/blob/master/logs_db.sql)<br><br>
                   
       - **IOS**     <br>     
            - [IOS 'Accounts3.sqlite' (Accounts)](https://github.com/kacos2000/queries/blob/master/Accounts3_sqlite.sql)<br>
            - [IOS 'calendar.sqlitedb' (Calendar)](https://github.com/kacos2000/queries/blob/master/calendar_sqlitedb.sql)<br>
            - [IOS 'Extras.db' (Calendar)](https://github.com/kacos2000/queries/blob/master/calendar_extras.sql)<br>
            - [IOS 'AddressBook.sqlitedb' (AddressBook)](https://github.com/kacos2000/queries/blob/master/AddressBook_sqlite.sql)<br>
            - [IOS 'AddressBookImages.sqlitedb' (AddressBook Images)](https://github.com/kacos2000/queries/blob/master/AddressBookImages_sqlite.sql)<br>
            - [IOS 11 'Photos.sqlite'](https://github.com/kacos2000/queries/blob/master/Photos_sqlite11.sql)<br>
            - [IOS 7+ 'Photos.sqlite'](https://github.com/kacos2000/queries/blob/master/Photos_sqlite.sql)<br>
            - [IOS 3 'Photos.sqlite'](https://github.com/kacos2000/queries/blob/master/Photos_sqlite3.sql)<br>
            - [IOS 'iPhotoLite.db'](https://github.com/kacos2000/queries/blob/master/iPhotoLitedb.sql)<br>
            - [IOS 'healthdb.sqlite'](https://github.com/kacos2000/queries/blob/master/healthdb.sql)<br>
            - [IOS 'healthdb_secure.sqlite'](https://github.com/kacos2000/queries/blob/master/healthdb_secure.sql)<br>
            - [IOS 'knowledgec.db'](https://github.com/kacos2000/queries/blob/master/knowledgec_db.sql)<br>
            - [IOS 'notes.sqlite'](https://github.com/kacos2000/queries/blob/master/notes_sqlite.sql)<br>
            - [IOS 'Recents' db (Mail)](https://github.com/kacos2000/queries/blob/master/recents.sql)<br>
            - [IOS 'sms.db' (SMS/iMessages)](https://github.com/kacos2000/queries/blob/master/sms_db.sql)<br>
            - [IOS 'callhistory.storedata' (Call history)](https://github.com/kacos2000/queries/blob/master/callhistory_storedata.sql)<br> 
            - [Hike Sticker Chat (com.bsb.hike)](https://github.com/kacos2000/queries/blob/master/bsb_hike_messagesDB_sqlite.sql)<br>
            - ['contacts.data' (Viber Messages)](https://github.com/kacos2000/queries/blob/master/Viber_Contacts_Data_messages.sql)<br> 
            - ['ChatStorage.sqlite' (WhatsApp Messages)](https://github.com/kacos2000/queries/blob/master/WhatsApp_Chatstorage_sqlite.sql)<br> 
            
 	   - **Windows 10**     <br>   	 
 	          - [Samsung Flow App 'Notifications.db'](https://github.com/kacos2000/queries/blob/master/Samsung_Flow_Notifications_db.sql) - *Note:* dB Files are EFS encrypted <br>
            - [Encapsulation.db](https://github.com/kacos2000/Queries/blob/master/Encapsulationdb.sql) found at 'C:\Windows\appcompat\encapsulation\Encapsulation.db' <br> 

    - **Windows 10**  
  from 'C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db' ([more info here](https://github.com/rathbuna/EventTranscript.db-Research))  
            - [ClipboardHistory](https://github.com/kacos2000/Queries/blob/master/ClipboardHistory.Service.sql) <br>
            - [SoftwareUpdateClientTelemetry](https://github.com/kacos2000/Queries/blob/master/SoftwareUpdateClientTelemetry.sql) <br> 
           
