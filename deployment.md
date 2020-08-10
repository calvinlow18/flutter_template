
# Flutter Android Production CI/CD

**NOTE**: First release always need to be done manually using appbundle file. This is to ensure that the application metadata is set up properly (not in **draft** status).

## Create Play Console Service Account

The purpose of creating service account for Google Play Console is to allow Jenkins to make use of this service account to upload the apk/app bundle and publish it.

### Prerequisite

- Access to [Google Play Console](https://play.google.com/apps/publish)

### Steps

1. Browse [Google Play Console](https://play.google.com/apps/publish) with preferred browser.
2. Login with Google Play Console credentials.
3. Click on **Settings** button on left drawer.
4. Click on **API access** button.
5. Click on **CREATE SERVICE ACCOUNT** button.
6. Follow the instructions on the page to create your service account (Ensure **Service Account User** role is provided to the service account).
7. Once the service account created, click **Done** in Google Play Console. The API Access page automatically refreshes, and your service account will be listed.
8. Click **GRANT ACCESS** to provide the service account the necessary rights to perform actions.
9. Click **View in Google Developers Console** link for the service account.
10. Click on target Service Account name.
11. Click **ADD KEY** dropdown and select **Create new key**.
12. Select **JSON** and click **CREATE**.
13. Private key will be downloaded to the machine. Store the private key securely.
14. This service account file will be used in Jenkins for publishing the app.

---

## Create New Application

### Prerequisite

- Access to [Google Play Console](https://play.google.com/apps/publish)
- Application Information
- Application Assets (images and initial app bundle signed with production key)

### Steps

1. Browse [Google Play Console](https://play.google.com/apps/publish) with preferred browser.
2. Login with Google Play Console credentials.
3. Ensure that the Google Play Console is in **classic mode**.
4. Ensure that the current scren is in **All applications** tab according to the left drawer.
5. Click on **CREATE APPLICATION** button.
6. Select the **Default language** if necessary.
7. Enter the **Title** of the application.
8. Click on **CREATE** button.
9. Enter all relevant information of the applicaton for **Store listing** section:
   - Title (Required)
   - Short description (Required)
   - Full description (Required)
   - Graphic assets
    - Hi-res icon (Required)
        - 512 x 512
        - 32-bit PNG
        - No transparent background
    - Screenshots (Required at least 2)
        - JPEG or 24-bit PNG (no alpha)
        - Min length of any side: 320px
        - Max length of any side: 3840px
        - At least 2 screenshots required overall
        - Maximum 8 screenshots per type
    - Feature Graphic (Required)
        - 1024 w x 500 h
        - JPG or 24-bit PNG (no alpha)
    - Application type (Required)
    - Category (Required)
    - Email (Required)
10. Repeat step 9 if there are other translations.
11. Click on **SAVE DRAFT**.

---

## Publish First Release

### Prerequisite

- Access to [Google Play Console](https://play.google.com/apps/publish)
- First release app bundle signed with production key

### Steps

1. Click on **App releases** on the left drawer.
2. Go to **Internal test track** section.
3. Click on **MANAGE** button.
4. Click on **CREATE RELEASE** button.
5. Click on **CONTINUE** button (recommanded to let Google manege and protect app signing key).
6. Click on **BROWSE FILES** or drag the app bundles into the grey upload zone area.
7. Ensure that app bundle is uploaded and processed successfully (A table will appear below grey upload zone area with the app bundle uploaded).
8. Continue on completing the required fields in tabs that have grey tick beside it.
9. Ensure that all grey tick changed to green tick which indicates all required information filled up.
10. Completed.

---

## Setup Application Metadata in Project

### Sync Play Store application metadata (One time only - Recommended)

#### Prerequisite

- Access to project repository
- [Play Console Service Account](#create-play-console-service-account)

#### Steps

1. Place Play Console Service Account at project root as play-store-service-account.json
1. Navigate into android folder, i.e.
    ```
    cd <project_root>/android
    ```
2. Run 
    ```
    bundle install && bundle exec fastlane supply init --track beta
    ```
3. Ensure that the following folders existed in the project folder structure:
    ```
    <project_root>
    └───android
        └───fastlane
            └───metadata
                └───android
                    └───en-US
                        ├───changelogs
                        └───images
                            ├───phoneScreenshots
                            ├───sevenInchScreenshots
                            ├───tenInchScreenshots
                            ├───tvScreenshots
                            └───wearScreenshots
    ```
4. Add .gitkeep into empty folders to ensure that the folder persists after pushing into git.
5. Verify if there are any existing metadata, the files should be downloaded in respective folder.
5. Submit PR.


### Manually Define Play Store Application Metadata (One time only - Not recommended)

1. Create the following folders if does not exist in the project:
    ```
    <project_root>
    └───android
        └───fastlane
            └───metadata
                └───android
                    └───en-US
                        ├───changelogs
                        └───images
                            ├───phoneScreenshots
                            ├───sevenInchScreenshots
                            ├───tenInchScreenshots
                            ├───tvScreenshots
                            └───wearScreenshots
    ```
2. Add .gitkeep into empty folders to ensure that the folder persists after pushing into git.
3. Submit PR.

---

## Setup Jenkins Pipeline

### Prerequisite
- Access to Jenkins
- Access to project git repository

#### STEP 1: Create new Job Item
1. Login into Jenkins.
2. Click on **New Item** on the left menu.
3. Enter item name in **Enter an item name** field.
4. Select **Multibranch Pipeline**.
5. Click **OK** button.

#### STEP 2: Update Job Item Configurations
1. Go to _Branch Sources_ section.
2. Click on **Add source** dropdown button.
3. Click on **Git**.
4. Enter the necessary information for **Project Repository** and **Credentials** (Get).
5. In **Behaviors** section, remove _Discover branches_ item by clicking on top right cross button.
6. Click on **Add** dropdown button in **Behaviors** section and select _Discover tags_.
7. Go to _Build Configuration_ section.
7. Change the **Script Path** to `JenkinsfileProd`.
8. Check **Periodically if not otherwise run** field.
9. Set the **Interval** to `2 minutes`.
10. Click **Apply** button.
11. Click **Save** button.

#### STEP 3: Verify 
1. Click on **Scan Multibranch Pipeline Now** on the left menu.
2. Click on **Scan Multibranch Pipeline Log** on the left menu.
3. Ensure that the log ends with:
    ```
    ...
    Checking tags...
    ...
    Finished: SUCCESS
    ```
    after complete scanning.
4. Completed.

---

## Update Release Version

1. Open _<project_root>/pubspec.yaml_.
2. Update version of the app in the following format:
    ```
    ...
    version: <version_name>:<version_code>
    ...
    ```
3. Create a changelog file for the release in _<project_root>/android/fastlane/metadata/android/&lt;locale&gt;/changelogs/<version_code>.txt_
4. (Optional) Update **title**, **short_description**, **full_description**, **video** and images in _<project_root>/android/fastlane/metadata/android/&lt;locale&gt;/**_.
4. Submit PR.

---

## Flow for Publishing App to Play Store

### Prerequisite
- Completed all above steps.

### Steps

1. Developer update the version and changelog of version in project.
2. Developer send PR to Team Lead to acknowledge on preparation to release.
3. Team Lead merge PR and create tag on latest commit (Normally at the commit that update version of the app) with the tag name as the version of the app.
4. Team Lead notify Ops Team to [trigger jenkins pipeline to publish app to Play Store](#trigger-jenkins-pipeline-to-publish-app-to-play-store).
5. Completed.

---

## Trigger Jenkins Pipeline to publish app to Play Store (For OPS Team)

### Prerequisite
- Tag name to be published (Normally will be the version of the app)
- Access to Jenkins

### Note
- Ensure that the version code of flutter app is incremented. Publish will fail if built app bundle have the same version code as any previous uploaded/published app bundle.
- Ensure Jenkins pipeline is already ready. If not, follow [Setup Jenkins Pipeline](#setup-jenkins-pipeline)

### Steps
1. Login into Jenkins.
2. Select the defined job.
3. Click on **Status** on the left menu.
4. Click on **Tags** tab.
5. Click on build button on the left of the target tag row.<br>
   **NOTE**: If the tag name does not exists, click on `Scan Multibranch Pipeline Now` to rescan the repository for latest tags available.
6. Ensure that the build run successfully.
7. Completed.