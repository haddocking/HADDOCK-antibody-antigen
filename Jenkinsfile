pipeline {
  agent {
    docker {
      image 'continuumio/miniconda3'
    }

  }


  stages {
    stage('Install') {
      steps {
        sh '''conda clean --index-cache
            conda env create --quiet
            cd anarci-1.3
            python2.7 setup.py install
            cd ..'''
      }
    }


    stage('Test') {
      steps {
        sh '''#!/bin/bash -ex
            source activate Ab-HADDOCK
            python -m coverage run -m unittest discover
            export CODECOV_TOKEN=7261158f-cf74-428f-bb21-157ef8900569
            codecov'''
      }
    }
  }
}