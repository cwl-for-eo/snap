# SNAP Graph inline

CWL allows creating files using the `InitialWorkDirRequirement`:

```yaml 
      InitialWorkDirRequirement:
        listing:
          - entryname: graph.xml
            entry: |-
```

The file `graph.xml` is created before executing the CommandLineTool. This approach is thus used to create the SNAP Graph with the content provided in the CWL document. 

This approach removes the `File` parameter used in the previous approach:

