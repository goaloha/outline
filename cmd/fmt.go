package cmd

import (
	"fmt"
	"os"

	"github.com/goaloha/outline/lib"
	"github.com/spf13/cobra"
)

// FmtCmd prints present configuration info
var FmtCmd = &cobra.Command{
	Use:   "fmt",
	Short: "format input",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		var docs lib.Docs
		for _, fp := range args {
			f, err := os.Open(fp)
			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}

			found, err := lib.Parse(f)
			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}
			docs = append(docs, found...)
		}

		noSort, err := cmd.Flags().GetBool("no-sort")
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		if !noSort {
			docs.Sort()
		}

		for _, doc := range docs {
			data, err := doc.MarshalIndent(0, "  ")
			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}

			fmt.Print(string(data) + "\n")
		}

	},
}

func init() {
	// FmtCmd.Flags().StringP("export", "e", "config.json", "path to configuration json file")
	FmtCmd.Flags().Bool("no-sort", false, "done alpha-sort fields & outline documents")
}
