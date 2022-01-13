#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "Genotype SVs using svtyper"

baseCommand: ["bash"]

requirements:
    - class: DockerRequirement
      dockerPull: "halllab/svtyper:v0.7.1-3c5218a"
    - class: ResourceRequirement
      ramMin: 12000

inputs:
 helper:
  type: File
  inputBinding:
   position: 1
 vcf:
  type: File
  inputBinding:
   position: 2
  doc: "VCF file of SVs to genotype"
 bam_one:
  type:
      - string
      - File
  secondaryFiles: [".bai"]
 bam_two:
  type:
      - string
      - File
  secondaryFiles: [".bai"] 

arguments:
 - valueFrom: |
    ${
      var x = "";
      if (inputs.bam_one.path) {
         x = x + String(inputs.bam_one.path);
      } else {
         x = x + inputs.bam_one;
      }
      if (inputs.bam_two.path) {
        x = x + "," + String(inputs.bam_two.path);
      } else {
        x = x + "," + inputs.bam_two;
      }
      return(x)
    }
   position: 3

outputs:
 genotyped:
  type: stdout

stdout: "$(inputs.vcf.nameroot).geno.vcf"
