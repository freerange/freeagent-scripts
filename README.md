## FreeAgent Scripts

Ruby scripts for querying/modifying the data in a FreeAgent account.

### Configuration

* Scripts in this project are intended to be run on your local machine.
* So you need to create a `.env` file in the project root directory:

```
CLIENT_ID=<OAuth-client-ID>
CLIENT_SECRET=<OAuth-client-secret>
```

* You should be able to set these environment variables using the values stored in the secure note named "FreeAgent API - Go Free Range app" in the shared 1Password vault.
* These values refer to the "Go Free Range" app (visit "App URL" in the secure note for more details).
* The first time you run one of the scripts, it will ask you to sign in to FreeAgent in a browser and authorize the application.
* The details of the access token thus obtained are saved to a file, `access-token.json`.
* The access token is usually valid for 1 hour. If you run one of the scripts within this time, you won't need to sign in again.
* Also the access token has a refresh token which is valid for a longer period. If the access token has expired it will automatically be refreshed, so you still won't need to sign in.
* If the refresh token has expired, you'll need to delete the `access-token.json` file, run the script again and sign in again.
* You can see the apps authorized by the currently logged in user via the FreeAgent settings: https://freerange.freeagent.com/settings/authorized_apps.
