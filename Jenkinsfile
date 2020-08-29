node {
    properties(
        [
            disableConcurrentBuilds()
        ]
    )

    stage('Clone repository'){
        checkout scm
    }

    try {

        stage('SIT Configuration'){
            FLAVOR = 'sit'
            FIB_APP_ID = '1:456849227714:android:3af82e169421840844e05b'
            FIB_TESTER_GROUPS = 'required'
        }

        stage('Build and Upload SIT'){
            withCredentials([
                [$class: "FileBinding", credentialsId: 'flutter-demo-sit-app-settings', variable: 'FIREBASE_KEY_FILE'],
                [$class: "FileBinding", credentialsId: 'flutter-demo-sit-app-settings', variable: 'APP_SETTINGS_LOCAL'],
                [$class: "FileBinding", credentialsId: 'flutter-demo-sit-keystore', variable: 'KEYSTORE'],
                [$class: "FileBinding", credentialsId: 'flutter-demo-sit-key-properties', variable: 'KEY_PROPERTIES'],
                // [$class: "FileBinding", credentialsId: 'flutter-demo-sit-google-services', variable: 'GOOGLE_SERVICES'],
            ]){
                sh "sudo cp appsettings.json appsettings.local.json && sudo chmod 755 appsettings.local.json"
                sh "sudo cp ${FIREBASE_KEY_FILE} firebasekeyfile.json && sudo chmod 755 firebasekeyfile.json"
                sh "sudo cp ${KEYSTORE} keystore.jks && sudo chmod 755 keystore.jks"
                sh "sudo cp ${KEY_PROPERTIES} android/key.properties && sudo chmod 755 android/key.properties"
                // sh "sudo cp ${GOOGLE_SERVICES} android/app/src/${FLAVOR}/google-services.json && sudo chmod 755 android/app/src/${FLAVOR}/google-services.json"
                def app = docker.build("flutter:demo", "--force-rm --rm -f Dockerfile .")
                app.inside('-v $WORKSPACE:/output -u root') {
                    sh """
                    cp /app/build/app/outputs/apk/sit/release/app-sit-release.apk /output
                    """
                }
                archiveArtifacts artifacts: 'app-sit-release.apk'
            }

            echo "SIT APK uploaded to Firebase App Distribution"
        }
    } catch (e) {
        throw e
    } finally {
        cleanUpDockerImage()
    }

    stage('Completed'){
        echo "Completed"
    }
}

def cleanUpDockerImage() {
    sh "sudo docker image prune -a -f --filter=label=stage=flutter-builder"
    sh "sudo docker image prune -a -f --filter=label=stage=flutter-deployer"
}