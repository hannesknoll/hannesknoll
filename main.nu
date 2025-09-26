#!/usr/bin/env nu

def create_markdown_tree [target_path: path] {
    def build [current_path: path, prefix: string] {
        let items = ls $current_path | sort-by name
        let last_idx = ($items | length) - 1

        $items | enumerate | each { |it|
            let i = $it.index
            let item = $it.item
            let is_last = ($i == $last_idx)

            let _tmp = if $is_last {
                ["└── ", $"($prefix)    "]
            } else {
                ["├── ", $"($prefix)│   "]
            }
            let connector = $_tmp.0
            let next_prefix = $_tmp.1

            if $item.type == 'dir' {
                $"($prefix)($connector)($item.name | path basename)\n(build $item.name $next_prefix)"
            } else {
                let file_name = $item.name | path basename
                let file_content = open $item.name | str replace --all "\n" ""
                $"($prefix)($connector)<a href=\"($file_content)\">($file_name)</a>\n"
            }
        } | str join
    }

    build $target_path ""
}

let md_tree = create_markdown_tree "Hannes Knoll"

$"# Hello there!
![Hello there bear]\(https://i.giphy.com/IThjAlJnD9WNO.webp\)

<pre>
👋🙂 <a href=\"https://hannesknoll.de\">Hannes Knoll</a>
($md_tree)
</pre>
" | save -f README.md
