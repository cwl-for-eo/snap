# Process SNAP graphs with CWL

The described method targets processing Earth Observation data with the SNAP Graph Processing Tool (GPT) using docker and CWL.

CWL is used to invoke the SNAP `gpt` command line tool and deals with all the docker volume mounts required to process a Graph and EO data available on the host.

The examples rely on a simple SNAP graph applying the `Calibration` operator to a Sentinel-1 GRD acquisition:

```xml
--8<--
sar-calibration.xml
--8<--
```

This SNAP graph contains parameters:

- `${inFile}` is the path to the Sentinel-1 `manifest.xml` file. This parameter is used in the `Read` Operator
- `${selPol}` is the selected polarization and thus leaving an option to process `VV` or `VH` (typically). This parameter is used in the `Calibration` Operator

Below there are two approaches described to process this graph using CWL:

- The SNAP graph is a local file and thus passed to CWL as a File (as a reference)
- The SNAP graph XML content is part of the CWL (included as a value)

## Graph as a File 

SNAP `gpt` is wrapped as a CWL `CommandLineTool` with:

```yaml
--8<--
sar-calibration-clt.cwl
--8<--
```

This CWL document takes three parameters:

```yaml
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
```

to construct a `gpt` invocation: 

```console
gpt <snap_graph> -PselPol=<polarization> -PinFile=<safe>
```

It is a best practice to create a CWL Workflow to wrap the `CommandLineTool`:

```yaml
--8<--
sar-calibration-file.cwl
--8<--
```

The CWL parameters file to run this CWL document contains:

```yaml
polarization: 'VV'
snap_graph: {class: File, path: ./sar-calibration.xml}
safe:
- {'class': 'Directory', 'path': './S1A_IW_GRDH_1SDV_20210615T050457_20210615T050522_038346_048680_F42E.SAFE'} 
```

## Graph inline

