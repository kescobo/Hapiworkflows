using Hapi
using Dagger

outfolder = "output/kneaddata/"
isdir(outfolder) || mkpath(outfolder)
 
rgx = build_regex("{sample}_S{well}_L00{lane}_R{pair}",
           (; sample = raw"FE|G\d+", 
              well   = raw"\d+",
              lane   = raw"[1-4]",
              pair   = raw"1|2")
)

rawfiles = glob_pattern("/grace/echo/batch017/rawfastq/", rgx)

samplegrp = groupdeps(rawfiles, [:sample, :well])


# outpattern = "{sample}_{well}_kneaddata_paired_{pair}.fastq"
function cat_pairs(grp)
    inputs = groupdeps(Hapi.deps(grp), [keys(params(grp))..., :pair])
    ouputs = [FileDependency(joinpath(outfolder, sample, "_kneaddata_paired_1.fastq.gz"),
                            (; params(grp)..., pair=d[:pair])) for p in pairs]


    
end


