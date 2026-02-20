# planscorer 0.0.5

* Adds a retry to `ps_ingest()` which sometimes needs to give the PlanScore API a moment to process the uploaded file before it can be ingested. This should help reduce the number of times users have to manually retry the upload process.

# planscorer 0.0.4

* Updates the multi-step upload process (internally) to match upstream changes in PlanScore API.

# planscorer 0.0.3

* Now depends on R 4.1.0 due to use of base pipe.
* Fixes writing to file issue in `ps_upload()` (#2).

# planscorer 0.0.1

* Added a `NEWS.md` file to track changes to the package.
