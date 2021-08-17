$graph:
- class: Workflow
  id: main
  doc: SNAP Sentinel-1 GRD Calibration
  label: SNAP Sentinel-1 GRD Calibration

  inputs:

    polarization:
      doc: Polarization channel 
      label: Polarization channel 
      type: string

    snap_graph:
      doc: SNAP Graph
      label: SNAP Graph
      type: File

    safe:
      doc: Sentinel-1 GRD product SAFE Directory
      label: Sentinel-1 GRD product SAFE Directory
      type: Directory
  
  outputs:
  - id: wf_outputs
    outputSource:
    - node_1/results
    type: Directory
  
  requirements:
    SubworkflowFeatureRequirement: {}
  
  steps:
    
    node_1:
      in:
        snap_graph: snap_graph
        polarization: polarization
        safe: safe
      out:
      - results
      run: '#sar-calibration'

- class: CommandLineTool
  id: sar-calibration
  
  requirements:
    DockerRequirement:
      dockerPull: snap-gpt
    EnvVarRequirement:
      envDef:
        PATH: /srv/conda/envs/env_snap/snap/bin:/usr/share/java/maven/bin:/usr/share/java/maven/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
    ResourceRequirement: {}
    InitialWorkDirRequirement:
      listing:
        - entryname: calibration.xml
          entry: |-
            <graph id="Graph">
              <version>1.0</version>
              <node id="Read">
                <operator>Read</operator>
                <sources/>
                <parameters class="com.bc.ceres.binding.dom.XppDomElement">
                  <file>${inFile}</file>
                  <formatName>SENTINEL-1</formatName>
                </parameters>
              </node>
              <node id="Calibration">
                <operator>Calibration</operator>
                <sources>
                  <sourceProduct refid="Read"/>
                </sources>
                <parameters class="com.bc.ceres.binding.dom.XppDomElement">
                  <sourceBands/>
                  <auxFile>Product Auxiliary File</auxFile>
                  <externalAuxFile/>
                  <outputImageInComplex>false</outputImageInComplex>
                  <outputImageScaleInDb>false</outputImageScaleInDb>
                  <createGammaBand>false</createGammaBand>
                  <createBetaBand>false</createBetaBand>
                  <selectedPolarisations>${selPol}</selectedPolarisations>
                  <outputSigmaBand>true</outputSigmaBand>
                  <outputGammaBand>false</outputGammaBand>
                  <outputBetaBand>false</outputBetaBand>
                </parameters>
              </node>
              <node id="Write">
                <operator>Write</operator>
                <sources>
                  <sourceProduct refid="Calibration"/>
                </sources>
                <parameters class="com.bc.ceres.binding.dom.XppDomElement">
                  <file>./cal.dim</file>
                  <formatName>BEAM-DIMAP</formatName>
                </parameters>
              </node>
            </graph>

  baseCommand: [gpt, calibration.xml]
  
  inputs:

    snap_graph:
      inputBinding:
        position: 1
      type: File

    polarization:
      inputBinding:
        position: 2
        prefix: -PselPol=
        separate: false
      type: string
    safe:
      inputBinding:
        position: 2
        prefix: -PinFile=
        separate: false
      type: Directory
  
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  
  stderr: std.err
  stdout: std.out

cwlVersion: v1.0