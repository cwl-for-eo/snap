# SNAP Graph as File

SNAP `gpt` is wrapped as a CWL `CommandLineTool` with:

```yaml
--8<--
snap/snap-cwl/sar-calibration-clt-file.cwl
--8<--
```

This CWL document takes three inputs:

```yaml hl_lines="16-33"
--8<--
snap/snap-cwl/sar-calibration-clt-file.cwl
--8<--
```

to construct a `gpt` invocation: 

```console
gpt <snap_graph> -PselPol=<polarization> -PinFile=<safe>
```

It is a best practice to create a CWL Workflow to wrap the `CommandLineTool`:

```yaml
--8<--
snap/snap-cwl/sar-calibration-file.cwl
--8<--
```

The CWL parameters file to run this CWL document contains:

```yaml
--8<--
snap/snap-cwl/sar-calibration-file.yml
--8<--
```

Finally, the execution is triggered with:

```console
cwltool sar-calibration-file.cwl sar-calibration-file.yml
```
