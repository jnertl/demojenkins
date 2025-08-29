pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                sh """
                    rm -rf middlewaresw
                    git clone --single-branch --branch main https://github.com/jnertl/middlewaresw.git
                """
            }
        }
        stage('Build') {
            steps {
                sh """
                    cd middlewaresw
                    bash ./build.sh
                """
            }
        }
        stage('Unit tests') {
            steps {
                sh """
                    cd middlewaresw
                    bash ./run_tests.sh
                """
            }
        }
        stage('Coverage report') {
            steps {
                sh """
                    cd middlewaresw
                    bash ./run_coverage.sh
                    zip -r coverage_html.zip coverage_html
                """
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'middlewaresw/coverage_html.zip', fingerprint: true
            archiveArtifacts artifacts: 'middlewaresw/gtestresults.xml', fingerprint: true
            xunit (
                thresholds: [ skipped(failureThreshold: '0'), failed(failureThreshold: '0') ],
                tools: [ GoogleTest(pattern: 'middlewaresw/gtestresults.xml') ]
            )            
        }
    }    
}
