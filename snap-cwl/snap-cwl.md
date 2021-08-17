# Process SNAP graphs with CWL

The described method targets processing Earth Observation data with the SNAP Graph Processing Tool (GPT) using docker and CWL.

CWL is used to invoke the SNAP `gpt` command line tool and deals with all the docker volume mounts required to process a Graph and EO data available on the host.

The examples rely on a simple SNAP graph applying the `Calibration` operator to a Sentinel-1 GRD acquisition:

```xml
--8<--
snap/snap-cwl/sar-calibration.xml
--8<--
```

This SNAP graph contains parameters:

- `${inFile}` is the path to the Sentinel-1 `manifest.xml` file. This parameter is used in the `Read` Operator
- `${selPol}` is the selected polarization and thus leaving an option to process `VV` or `VH` (typically). This parameter is used in the `Calibration` Operator

CWL is used to wrap the SNAP `gpt` executable:

```console
gpt sar-calibration.xml -PselPol=${selPol} -PinFile=${inFile}
```

There are two approaches described to process this graph using CWL:

- The SNAP graph is a local file and thus passed to CWL as a File (as a reference)
- The SNAP graph XML content is part of the CWL (included as a value) 

