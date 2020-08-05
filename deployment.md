
# Android CI/CD Setup

## Prerequisite

- Access to Google Play Console
- Application Information
- Application Assets (images and initial app bundle signed with production key)
- Flutter project with fastlane initialized in android folder.

## Create new application

1. Go to [Google Play Console](https://play.google.com/apps/publish)
2. Login with Google Play Console Credentials provided.
3. Ensure that the Google Play Console is in classic mode.
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
12. Continue on completing the required fields in tabs that have grey tick beside it.
13. Ensure that all grey tick changed to green tick which indicates all required information filled up.
14. Completed.

## Setup App releases

1. Click on **App releases** on the left drawer.
2. Go to **Internal test track** section.
3. Click on **MANAGE** button.
4. Click on **CREATE RELEASE** button.
5. Click on **CONTINUE** button (recommanded to let Google manege and protect app signing key).
6. Click on **BROWSE FILES** or drag the app bundles into the grey upload zone area.
7. Ensure that app bundle is uploaded and processed successfully (A table will appear below grey upload zone area with the app bundle uploaded).



## Assign app package name to application (First time only)

1. Click target application at **All applications** screen.
2. Click on **App releases** on the left drawer.
3. Scroll down to **Internal test track** section.
4. Click on **MANAGE** button at **Internal test**.
5. Click on **CREATE RELEASE** button.
6. Click on **CONTINUE** button (recommanded to let Google manege and protect app signing key).
7. Click on **BROWSE FILES** or drag the app bundles into the grey upload zone area.
8. Ensure that app bundle is uploaded and processed successfully (A table will appeat below grey upload zone area with the app bundle uploaded).
9. Click **DISCARD** button.
10. Click **CONFIRM** button.
11. Go back to **All applications** screen.
12. Ensure that the correct package name appears below the application name.

## Sync Play Store application metadata (First time only - Recommended)

1. Ensure that play-store-service-account.json
1. Navigate into android folder, i.e.
    ```
    cd <project_root>/android
    ```
2. Run 
    ```
    bundle install && bundle exec fastlane supply init
    ```
3. Ensure that the metadata folder have the following folder structure:
    ```
    project_root
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
4. Add .gitkeep empty file in folders to ensure that the folder persists after pushing into git.
5. Submit PR.

## Update release version

1. Open _<project_root>/pubspec.yaml_.
2. Update version of the app in the following format:
    ```
    ...
    version: <version_name>:<version_code>
    ...
    ```
3. Create a changelog file for the release in _<project_root>/android/fastlane/metadata/android/&lt;locale&gt;/changelogs/<version_code>.txt_
4. Update **title**, **short_description**, **full_description**, **video** and images in _<project_root>/android/fastlane/metadata/android/&lt;locale&gt;/**_ if required.
4. Submit PR.

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

## Flow for Publishing App to Play Store

### Prerequisite
- Completed [Setup Jenkins Pipeline](#setup-jenkins-pipeline).
- 

### Steps

1. Developer update the version and changelog of version in project.
2. Developer send PR to Team Lead to acknowledge on preparation to release.
3. Team Lead merge PR and create tag on latest commit with the tag name as the version of the app.
4. Team Lead notify Ops Team to [trigger jenkins pipeline to publish app to Play Store](#trigger-jenkins-pipeline-to-publish-app-to-play-store).
5. Completed.

## Trigger Jenkins Pipeline to publish app to Play Store

### Prerequisite
- Tag name to be published (Normally will be the version of the app)
- Access to Jenkins

### Steps
1. Login into Jenkins.
2. Select the defined job.
3. Click on **Status** on the left menu.
4. Click on **Tags** tab.
5. Click on build button on the left of the target tag row.
   
   **NOTE**: If the tag name does not exists, click on `Scan Multibranch Pipeline Now` to rescan the repository for latest tags available.
6. Ensure that the build run successfully.
7. Completed.