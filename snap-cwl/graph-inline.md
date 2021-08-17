# SNAP Graph inline

CWL allows creating files using the `InitialWorkDirRequirement`:

```yaml 
      InitialWorkDirRequirement:
        listing:
          - entryname: graph.xml
            entry: |-
```

The file `graph.xml` is created before executing the CommandLineTool. This approach is thus used to create the SNAP Graph with the content provided in the CWL document. 

This approach removes the `File` parameter used in the previous section and provides a self-standing CWL document:

```yaml hl_lines="11-54"
--8<--
snap/snap-cwl/sar-calibration-clt-inline.cwl
--8<--
```

The `baseCommand` is updated to add the `calibration.xml` argument:

```yaml hl_lines="56-56"
--8<--
snap/snap-cwl/sar-calibration-clt-inline.cwl
--8<--
```

The Workflow is updated accordingly: 


